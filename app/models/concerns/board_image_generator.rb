require "pp"

class BoardImageGenerator
  class << self
    def cache_root
      Rails.public_path.join("system", "board_images")
    end

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
      opts = params.deep_dup

      if opts[:image_preset] == "small"
        opts.update({
                      width: 320,
                      height: 256,
                      piece_pull_down_rate:  { black: 0.06, white: 0      },
                      piece_pull_right_rate: { black: 0.06, white: -0.045 },
                    })
      end

      opts                                                # => {"width" => "",   "height" => "1234" }
      opts = opts.to_options                           # => {:width  => "",   :height  => "1234" }
      hash = opts.transform_values { |e| native_cast(e) } # => {:width  => "",   :height  => 1234   }
      hash = hash.reject { |k, v| v.blank? }                 # => {                 :height  => 1234   }
      opts = image_default_options.merge(hash)            # => {:width  => 1200, :height  => 1234   }

      opts = opts.deep_symbolize_keys # opts[:piece_pull_right_rate][:black] でアクセスできるようにするため

      # 最大値を超えないように補正
      image_default_options.each do |key, val|
        opts[key] = opts[key].clamp(1, val)                   # => {:width  => 1200, :height  => 630    }
      end

      opts
    }.call
  end

  def turn
    @turn ||= record.adjust_turn(params[:turn])
  end

  private

  def real_path
    self.class.cache_root.join(*dir_parts, filename)
  end

  def filename
    "#{unique_key}.png"
  end

  def unique_key
    @unique_key ||= Digest::MD5.hexdigest(unique_key_source_string)
  end

  # なるべく画像を共有したいのであってレコード毎にユニークにしたいわけじゃないので record.to_param を入れてはいけない
  def unique_key_source_string
    [
      1,
      "blob",
      record.sfen_hash,
      turn,
      to_blob_options,
    ].join(":")
  end

  def not_found_then_generate
    if @options[:disk_cache_enable] && real_path.exist?
      return
    end

    force_generate
  end

  def to_blob
    parser = Bioshogi::Parser.parse(record.sfen_body, parser_options)
    parser.to_blob(to_blob_options)
  end

  def force_generate
    real_path.dirname.mkpath
    real_path.binwrite(to_blob)
    real_path.sub_ext(".rb").write(to_blob_options.pretty_inspect)
  end

  # system/ だと /s/system になってしまうので / から始めるようにする
  def browser_path
    "/" + real_path.relative_path_from(Rails.public_path).to_s
  end

  def dir_parts
    unique_key.match(/(.{2})(.{2})/).captures
  end

  def native_cast(e)
    case
    when e == "true"
      true
    when e == "false"
      false
    else
      Integer(e) rescue Float(e) rescue e
    end
  end

  def image_default_options
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
end
