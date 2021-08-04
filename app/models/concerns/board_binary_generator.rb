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
  end

  def to_blob_options
    @to_blob_options ||= -> {
      opts = params.dup

      Bioshogi::BinaryFormatter.assert_valid_keys(params.except(:to_format))

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

      default_size.each do |key, val|
        if v = opts[key]
          opts[key] = v.to_i.clamp(0, val)                   # => {:width  => 1200, :height  => 630    }
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
    @options[:disk_cache_enable] && real_path.exist?
  end

  # system/ だと /s/system になってしまうので / から始めるようにする
  def browser_path
    "/" + real_path.relative_path_from(Rails.public_path).to_s
  end

  def not_found_then_generate
    if file_exist?
      return
    end

    force_generate
  end

  private

  def real_path
    @real_path ||= self.class.cache_root.join(*dir_parts, filename)
  end

  def filename
    "#{unique_key}.#{to_format}"
  end

  def unique_key
    @unique_key ||= Digest::MD5.hexdigest(unique_key_source_string)
  end

  # なるべく画像を共有したいのであってレコード毎にユニークにしたいわけじゃないので record.to_param を入れてはいけない
  def unique_key_source_string
    [
      PAPPER,
      to_format,
      record.sfen_hash,
      turn,
      to_blob_options,
    ].join(":")
  end

  def to_blob
    parser = Bioshogi::Parser.parse(record.sfen_body, parser_options)
    parser.animation_formatter(to_blob_options.merge(animation_format: to_format)).to_blob

    # if [:gif, :webp, :apng].include?(to_format)
    #   parser.animation_formatter(to_blob_options.merge(animation_format: to_format)).to_blob
    # elsif [:png].include?(to_format)
    #   # options = to_blob_options.except(Bioshogi::ImageFormatter.default_params.keys)
    #   parser.image_formatter(options.merge(image_format: to_format)).to_blob
    # else
    #   parser.public_send("to_#{to_format}", to_blob_options)
    # end

  end

  def force_generate
    real_path.dirname.mkpath
    real_path.binwrite(to_blob)
    Pathname("#{real_path}.rb").write(to_blob_options.pretty_inspect) # 同じディレクトリにどのようなオプションで生成したかを吐いておく
  end

  def dir_parts
    unique_key.match(/(.{2})(.{2})/).captures
  end

  def native_cast(e)
    case e
    when Integer, Float
      e
    when e == "true"
      true
    when e == "false"
      false
    when e == "on"
      true
    when e == "off"
      false
    when e.kind_of?(String)
      Integer(e) rescue Float(e) rescue e
    end
  end

  def default_size
    {
      width: 1200,
      height: 630,
    }
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

  def to_format
    v = params[:to_format].presence || "png"
    # if ["gif", "webp", "apng", "png", "jpg", "bmp"].exclude?(v)
    #   raise ArgumentError, v.inspect
    # end
    v
  end
end
