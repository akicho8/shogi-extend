module OgpCop
  extend self

  # def ogp_params_set(options = {})
  #   @provide(:ogp_params_set, as_meta_tags(options))
  # end

  # twitter は投稿時に指定された URL を見ているだけで og:url や twitter:url を見ていない
  def as_meta_tags(h, options = nil)
    options ||= {}
    options = options.clone

    # title などは空にすると twitter card がでない
    twitter_card_default.each do |key, value|
      options[key] = options[key].presence || value
    end

    twitter_prefix_set = [:card, :site, :creator].to_set

    options.collect { |key, val|
      if val.present?
        if twitter_prefix_set.include?(key)
          prefix = :twitter
        else
          prefix = :og
        end
        if key == :image
          unless val.kind_of?(String)
            val = h.url_for(val)
          end
          val = h.image_url(val) # image_url を通すことで http から始まるパスに変換できる
        end
        h.tag.meta(name: "#{prefix}:#{key}", content: val)
      end
    }.compact.join.html_safe
  end

  def twitter_card_default
    {
      :card    => "summary_large_image", # summary or summary_large_image
      :site    => "@sgkinakomochi",
      :title   => AppConfig[:app_name],
      :creator => "@sgkinakomochi",
      :image   => "apple-touch-icon.png",
    }
  end
end
