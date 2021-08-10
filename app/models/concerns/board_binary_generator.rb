require "pp"

class BoardBinaryGenerator
  PAPPER = 1
  PARAM_KEYS = [:xout_format_key, :turn] # params のうち、このクラスだけで扱うパラメータ

  class << self
    def cache_root
      Rails.public_path.join("system", "board_images")
    end

    # cap production rails:runner CODE='BoardBinaryGenerator.cache_delete_all'
    def cache_delete_all
      FileUtils.rm_rf(cache_root)
    end
  end

  attr_accessor :record
  attr_accessor :params

  def initialize(record, params = {}, options = {}, &block)
    @record = record

    if params.respond_to?(:to_unsafe_h)
      params = params.to_unsafe_h
    end

    @params = {
    }.merge(params.to_options)

    @options = {
      disk_cache_enable: Rails.env.production? || Rails.env.staging? || Rails.env.test?,
    }.merge(options)

    if block_given?
      yield self
    end
  end

  def to_browser_path
    not_found_then_generate
    browser_path
  end

  def to_real_path
    not_found_then_generate
    real_path
  end

  def cache_delete
    FileUtils.rm_f(real_path)
    FileUtils.rm_f("#{real_path}.rb")
  end

  def to_blob_options
    @to_blob_options ||= -> {
      # このクラスだけで扱うパラメータを除いてからチェック
      Bioshogi::BinaryFormatter.assert_valid_keys(params.except(PARAM_KEYS))

      opts = params.dup
      opts = opts.deep_symbolize_keys

      # if opts[:image_preset] == "small"
      #   opts.update({
      #                 width: 320,
      #                 height: 256,
      #                 piece_pull_down_rate:  { black: 0.06, white: 0      },
      #                 piece_pull_right_rate: { black: 0.06, white: -0.045 },
      #               })
      # end

      # opts                                                # => {"width" => "",   "height" => "1234" }
      # opts = opts.to_options                           # => {:width  => "",   :height  => "1234" }
      # hash = opts.transform_values { |e| native_cast(e) } # => {:width  => "",   :height  => 1234   }
      # hash = hash.reject { |k, v| v.blank? }                 # => {                 :height  => 1234   }
      # opts = default_size.merge(hash)            # => {:width  => 1200, :height  => 1234   }
      #
      # opts = opts.deep_symbolize_keys # opts[:piece_pull_right_rate][:black] でアクセスできるようにするため

      default_size.each do |e|
        if v = opts[e[:key]].presence || e[:default]
          v = v.to_i
          v = v.clamp(0, e[:max])
          opts[e[:key]] = v
        end
      end

      opts.update(xout_format_info.override_options)

      opts = opts.slice(*Bioshogi::BinaryFormatter.all_options.keys) # 不要なオプションを取る

      opts
    }.call
  end

  def turn
    @turn ||= record.adjust_turn(params[:turn])
  end

  def file_exist?
    real_path.exist?
  end

  # system/ だと /s/system になってしまうので / から始めるようにする
  def browser_path
    "/" + real_path.relative_path_from(Rails.public_path).to_s
  end

  def browser_url
    UrlProxy.wrap2(path: browser_path)
  end

  def not_found_then_generate
    if @options[:disk_cache_enable] && file_exist?
      return
    end

    force_generate
  end

  def real_path
    @real_path ||= self.class.cache_root.join(*dir_parts, filename)
  end

  def xout_format_key
    params[:xout_format_key].presence || "is_format_png"
  end

  def xout_format_info
    XoutFormatInfo.fetch(xout_format_key)
  end

  def filename
    "#{unique_key}.#{xout_format_info.real_ext}"
  end

  def ffprobe_info
    if real_path.exist?
      # `file -LzbN #{real_path}`.strip
      # `identify #{real_path}`.strip
      Dir.chdir(real_path.dirname) do
        # `ffprobe -hide_banner -i #{real_path.basename} 2>&1`.strip
        {
          :pretty_format => JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner -pretty #{real_path.basename}`),
          :direct_format => JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner         #{real_path.basename}`),
        }
      end
    end
  end

  def file_size
    if real_path.exist?
      real_path.size
    end
  end

  private

  def unique_key
    @unique_key ||= Digest::MD5.hexdigest(unique_key_source_string)
  end

  # なるべく画像を共有したいのであってレコード毎にユニークにしたいわけじゃないので record.to_param を入れてはいけない
  def unique_key_source_string
    [
      PAPPER,
      xout_format_info.key,
      record.sfen_hash,
      turn,
      to_blob_options,
    ].join(":")
  end

  def to_blob
    parser = Bioshogi::Parser.parse(record.sfen_body, parser_options)
    if false
      parser.public_send("to_#{xout_format_info.real_ext}", to_blob_options) # FIXME: やっぱりこのインターフェイスにした方がいいかも
    else
      if xout_format_info.formatter == "image"
        parser.image_formatter(to_blob_options.merge(image_format: xout_format_info.real_ext)).to_blob_binary
      else
        # mp4 は write で吐いたファイルを読み込んで返す
        # こちらで png を処理すると foo-1.png などが生成されて to_write_binary は "" を返してしまう
        parser.animation_formatter(to_blob_options.merge(animation_format: xout_format_info.real_ext)).to_write_binary
      end
    end
  end

  def force_generate
    real_path.dirname.mkpath
    real_path.binwrite(yuv420_convert(to_blob))
    Pathname("#{real_path}.rb").write(to_blob_options.pretty_inspect) # 同じディレクトリにどのようなオプションで生成したかを吐いておく
  end

  def dir_parts
    unique_key.match(/(.{2})(.{2})/).captures
  end

  # def native_cast(e)
  #   case e
  #   when Integer, Float
  #     e
  #   when e == "true"
  #     true
  #   when e == "false"
  #     false
  #   when e == "on"
  #     true
  #   when e == "off"
  #     false
  #   when e.kind_of?(String)
  #     Integer(e) rescue Float(e) rescue e
  #   end
  # end

  # 基本サイズは指定されてなくて下位互換のためOGP画像推奨サイズを初期値にしている
  # 動画の場合は 4:3 にした方がいい
  # 動画の場合はサイズが渡ってくる
  def default_size
    [
      { key: :width,  default: 1200, max: Rails.env.development? ? 3200 : 1600, },
      { key: :height, default:  630, max: Rails.env.development? ? 3200 : 1200, },
    ]
  end

  # PNGを最速で生成するため戦術チェックなどスキップできるものはぜんぶスキップする
  def parser_options
    {
      # :skill_monitor_enable           => false,
      # :skill_monitor_technique_enable => false,
      :typical_error_case => :embed, # validate_enable しているのでこのオプションは使わない？
      :candidate_enable   => false,
      :validate_enable    => false,
      :mediator_class     => Bioshogi::MediatorFast,
      :turn_limit         => turn,
    }
  end

  # "-strict -2" はAACを使う場合に指定するm
  # https://www.84kure.com/blog/2014/10/13/ffmpeg-%E3%82%88%E3%81%8F%E4%BD%BF%E3%81%86%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E8%A6%9A%E3%81%88%E6%9B%B8%E3%81%8D/
  def yuv420_convert(bin)
    if xout_format_info.force_convert_to_yuv420p
      i_path = real_path.dirname + "i_#{real_path.basename}"
      o_path = real_path.dirname + "o_#{real_path.basename}"

      real_path.dirname.mkpath
      i_path.binwrite(bin)

      # command = "ffmpeg -y -i #{i_path} -vf 'scale=if(gte(iw\,ih)\,min(1280\,iw)\,-2):if(lt(iw\,ih)\,min(1280\,ih)\,-2)' -c:v libx264 -x264-params crf=16 -pix_fmt yuv420p -color_primaries bt709 -color_trc bt709 -colorspace bt709 -color_range tv -c:a copy #{o_path}"
      # command = "ffmpeg -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p -strict -2 -acodec aac -color_primaries bt709 -color_trc bt709 -colorspace bt709 -color_range tv -c:a copy #{o_path}"

      # command = "ffmpeg -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p -strict -2 -acodec aac #{o_path}"
      # command = "ffmpeg -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p -crf 18 -preset medium -tune stillimage #{o_path}"
      audio_options = "-strict -2 -acodec aac"
      command = "ffmpeg -v warning -hide_banner -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p #{o_path}"

      # command = "ruby -e '1 / 0'"
      Pathname("#{real_path}.ffmpeg_command.txt").write(command.squish)
      # Dir.chdir(real_path.dirname) do
      system(command, exception: true)
      # end

      bin = o_path.read

      if Rails.env.development?
      else
        FileUtils.rm_f(i_path)
        FileUtils.rm_f(o_path)
      end
    end
    bin
  end
end
