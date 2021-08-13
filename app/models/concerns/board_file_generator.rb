require "pp"

class BoardFileGenerator
  PAPPER = 1

  # FIXME: これらは params ではなく options にいれるべき？
  # params のうち、このクラスだけで扱うパラメータ
  PARAM_KEYS = [
    :xout_format_key,
    :turn,
    :video_fps,
    :basename_prefix,
  ]

  class << self
    def cache_root
      Rails.public_path.join("system", "board_images")
    end

    # cap production rails:runner CODE='BoardFileGenerator.cache_delete_all'
    def cache_delete_all
      FileUtils.rm_rf(cache_root)
    end
  end

  attr_accessor :record
  attr_accessor :params

  delegate :real_ext, to: :xout_format_info

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
    generate_unless_exist
    browser_path
  end

  def to_real_path
    generate_unless_exist
    real_path
  end

  def cache_delete
    FileUtils.rm_f(real_path)
    FileUtils.rm_f("#{real_path}.rb")
  end

  def xxx_formatter_options
    @xxx_formatter_options ||= -> {
      # このクラスだけで扱うパラメータを除いてからチェック
      # Bioshogi::BinaryFormatter.assert_valid_keys(params.except(*PARAM_KEYS))

      opts = params.dup
      opts = opts.deep_symbolize_keys
      opts = opts.slice(*Bioshogi::BinaryFormatter.all_options.keys) # 不要なオプションを取る

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

  def generate_unless_exist
    if @options[:disk_cache_enable] && file_exist?
      return
    end

    force_generate
  end

  def real_path
    @real_path ||= self.class.cache_root.join(*dir_parts, disk_filename)
  end

  def xout_format_key
    params[:xout_format_key].presence || "is_format_png"
  end

  def xout_format_info
    XoutFormatInfo.fetch(xout_format_key)
  end
  # system 以下に格納するとき用のファイル名
  # 同じパラメータなら同じになるようにする
  # 2回同じパラメータで生成しようとしたときに、2回目に1回目のファイルを参照できるなくなるから日付を含めてはいけない
  def disk_filename
    # "#{basename_prefix}_#{basename_human_parts.join("_")}.#{real_ext}"
    "#{unique_key}.#{real_ext}"
  end

  # Rails側からダウンロードするときのわかりやすい名前
  # def filename_human
  #   # "#{basename_prefix}_#{basename_human_parts.join("_")}.#{real_ext}"
  #   basename = basename_human_parts.join("_")
  #   "#{basename}.#{real_ext}"
  # end

  # def filename_human
  #   "#{basename_human}.#{real_ext}"
  # end

  def basename_human_parts(direct_format)
    parts = []
    # parts << [xxx_formatter_options[:width], xxx_formatter_options[:height]].join("x")
    # if xout_format_info.force_convert_to_yuv420p
    #   ffprobe_direct
    #   parts << "#{video_fps}fps"
    # end
    e = direct_format["streams"][0]
    if (w = e["coded_width"]) && (h = e["coded_height"])
      parts << "#{w}x#{h}"
    end
    if real_ext.in?(["mp4", "mov"])
      if v = e["r_frame_rate"]
        parts << "#{v.to_i}fps"
      end
      if v = e["bit_rate"]
        parts << "br#{v.to_i / 1024}Kbit"
      end
      if v = e["duration"]
        parts << "#{v.to_f.ceil}s"
      end
      if v = e["pix_fmt"]
        parts << v
      end
    else
      # ...
    end
    # end
    parts
  end

  def ffprobe_info
    if real_path.exist?
      Dir.chdir(real_path.dirname) do
        {
          :pretty_format => JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner -pretty #{real_path.basename}`),
          :direct_format => JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner         #{real_path.basename}`),
        }
      end
    end
  end

  def ffprobe_direct
    # @ffprobe_direct ||= -> {
    if real_path.exist?
      JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner #{real_path}`)
    end
    # }.call
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
      xxx_formatter_options,
    ].join(":")
  end

  def to_blob
    parser = Bioshogi::Parser.parse(record.sfen_body, parser_options)
    if false
      parser.public_send("to_#{real_ext}", xxx_formatter_options) # FIXME: やっぱりこのインターフェイスにした方がいいかも
    else
      if xout_format_info.formatter == "image"
        parser.image_formatter(xxx_formatter_options.merge(image_format: real_ext)).to_blob_binary
      else
        # mp4 は write で吐いたファイルを読み込んで返す
        # こちらで png を処理すると foo-1.png などが生成されて to_write_binary は "" を返してしまう
        parser.animation_formatter(xxx_formatter_options.merge(animation_format: real_ext)).to_write_binary
      end
    end
  end

  def force_generate
    real_path.dirname.mkpath
    real_path.binwrite(yuv420_convert(to_blob))
    Pathname("#{real_path}.rb").write(xxx_formatter_options.pretty_inspect) # 同じディレクトリにどのようなオプションで生成したかを吐いておく
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
      command = "ffmpeg -r #{video_fps} -v warning -hide_banner -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p #{o_path}"

      # command = "ruby -e '1 / 0'"
      Pathname("#{real_path}.ffmpeg_command.txt").write(command.squish)
      # Dir.chdir(real_path.dirname) do
      case
      when false
        # ffmpeg が 1 で終了したことしかわからない
        system(command, exception: true)
      when true
        # ffmpeg が 1 で終了したときのエラー出力がわかる
        status, stdout, stderr = systemu(command)
        if !status.success?
          raise StandardError, stderr.strip
        end
      end
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

  def video_fps
    params[:video_fps].to_f
  end

  def basename_prefix
    params[:basename_prefix].presence || unique_key.slice(0, 8)
  end
end
