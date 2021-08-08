require "pp"

class BoardBinaryGenerator
  PAPPER = 1

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
      Bioshogi::BinaryFormatter.assert_valid_keys(params.except(:xout_format_key))

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
        if v = opts[e[:key]]
          v = v.to_i
          v = v.clamp(0, e[:max])
          opts[e[:key]] = v
        end
      end

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
      if xout_format_info.real_ext.in?(["png", "jpg", "bmp"]) # FIXME: ぽりもるふぃっく
        # png は to_blob の結果とする
        parser.image_formatter(to_blob_options.merge(image_format: xout_format_info.real_ext)).to_blob_binary
      else
        # mp4 は write で吐いたファイルを読み込んで返す
        # こちらで png を処理すると foo-1.png などが生成されて to_write_binary は "" を返してしまう
        parser.animation_formatter(to_blob_options.merge(animation_format: xout_format_info.real_ext)).to_write_binary
      end
    end
  end

  def adjustment_blob
    bin = to_blob
    if xout_format_info.twitter_support
      real_path.dirname.mkpath
      in_path = real_path.dirname + "tmp_#{real_path.basename}"
      in_path.binwrite(bin)
      out_path = real_path.dirname + "out_#{real_path.basename}"
      command = "ffmpeg -y -i #{in_path} -vcodec libx264 -pix_fmt yuv420p -strict -2 -acodec aac #{out_path}"
      system(command)
      bin = out_path.read
      # FileUtils.rm_f(in_path)
      # FileUtils.rm_f(out_path)
    end
    bin
  end

  def force_generate
    real_path.dirname.mkpath
    real_path.binwrite(adjustment_blob)
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
end
