module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  delegate :fa_icon_tag, :icon_tag, to: Icon

  def html_title
    @override_page_title || full_html_title
  end

  def full_html_title
    titles = [AppConfig[:app_name], content_for(:page_title), @page_title]
    titles.flatten.reject(&:blank?).reverse.join(" - ")
  end

  concerning :FlashMethods do
    delegate :normalized_flash, :flash_danger_notify_tag, :toast_flash, to: :flash_info

    def flash_info
      @flash_info ||= FlashInfo.new(self)
    end
  end

  def bulma_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |e| content_tag(:li, e) }.join.html_safe
    sentence = I18n.t('errors.messages.not_saved', count: resource.errors.count, resource: resource.class.model_name.human.downcase)

    tag.div(:class => ["notification", "is-warning"]) { |;out|
      out = []
      out << tag.h5(sentence)
      out << tag.div(:class => "content") do
        tag.ul(messages)
      end
      out.join.html_safe
    }.html_safe
  end

  def twitter_card_registry(**options)
    provide(:twitter_card_registry, twitter_card_tag_build(options))
  end

  # twitter は投稿時に指定された URL を見ているだけで og:url や twitter:url を見ていない
  def twitter_card_tag_build(**options)
    options = {
      card: "summary_large_image", # summary or summary_large_image
      site: "@sgkinakomochi",
      title: AppConfig[:app_name],
      creator: "@sgkinakomochi",
      url: request.url,
      image: "apple-touch-icon.png",
    }.merge(options)

    twitter_prefix_set = [:site, :creator].to_set

    options.collect { |key, val|
      if val.present?
        if twitter_prefix_set.include?(key)
          prefix = :twitter
        else
          prefix = :og
        end
        if key == :image
          val = image_url(val)
        end
        tag.meta(name: "#{prefix}:#{key}", content: val)
      end
    }.compact.join.html_safe
  end
end
