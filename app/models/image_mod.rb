module ImageMod
  extend ActiveSupport::Concern

  def image_default_options
    {
      width: 1200,
      height: 630,
    }
  end

  # http://localhost:3000/w/hatae72-kinakom0chi-20200311_231857.png?width=&turn=21
  def param_as_to_png_options(params = {})
    if params.respond_to?(:to_unsafe_h)
      params = params.to_unsafe_h
    end

    params                                                        # => {"width" => "",   "height" => "1234" }
    params = params.to_options                                    # => {:width  => "",   :height  => "1234" }
    hash = params.transform_values { |e| str_to_native_value(e) } # => {:width  => "",   :height  => 1234   }
    hash = hash.reject { |k, v| v.blank? }                        # => {                 :height  => 1234   }
    options = image_default_options.merge(hash)                   # => {:width  => 1200, :height  => 1234   }

    # 最大値を超えないように補正
    image_default_options.each do |key, val|
      options[key] = options[key].clamp(1, val)                   # => {:width  => 1200, :height  => 630    }
    end

    options
  end

  # 局面画像の動的生成
  def to_dynamic_png(params = {})
    turn = adjust_turn(params[:turn])
    options = param_as_to_png_options(params)
    options_hash = Digest::MD5.hexdigest(options.to_s)
    cache_key = [to_param, "png", sfen_hash_or_create, turn, options_hash].join(":") # id:png:board:turn:options
    Rails.cache.fetch(cache_key, expires_in: 1.week) do
      parser = Bioshogi::Parser.parse(sfen_body_or_create, bioshogi_parser_options.merge(turn_limit: turn))
      parser.to_png(options)
    end
  end

  def modal_on_index_url(params = {})
    params = {
      modal_id: to_param,
      title: "",
      description: "",
    }.merge(params)

    params[:turn] = adjust_turn(params[:turn])
    params[:flip] = adjust_flip(params[:flip])

    Rails.application.routes.url_helpers.full_url_for([self.class, params])
  end

  def tweet_show_url(params = {})
    Rails.application.routes.url_helpers.full_url_for([self, params])
  end

  def tweet_body(**options)
    out = []
    out << title
    out << description
    # out << (options[:url] || tweet_show_url) # Twitter側の仕様でURLは最後にすることでURLの表示がツイート内容から消える
    out << (options[:url] || modal_on_index_url) # Twitter側の仕様でURLは最後にすることでURLの表示がツイート内容から消える
    out.reject(&:blank?).join("\n")
  end

  # FIXME: これは js の方に書くべき
  def tweet_window_url(**options)
    "https://twitter.com/intent/tweet?text=#{ERB::Util.url_encode(tweet_body(options))}"
  end

  private

  def str_to_native_value(e)
    case
    when e == "true"
      true
    when e == "false"
      false
    else
      Integer(e) rescue Float(e) rescue e
    end
  end

  # PNGを最速で生成するため戦術チェックなどスキップできるものはぜんぶスキップする
  def bioshogi_parser_options
    {
      # :skill_monitor_enable           => false,
      # :skill_monitor_technique_enable => false,
      :typical_error_case => :embed, # validate_skip しているのでこのオプションは使わない？
      :candidate_skip     => true,
      :validate_skip      => true,
      :mediator_class     => Bioshogi::MediatorFast,
    }
  end
end
