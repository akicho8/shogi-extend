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
    delegate :normalized_flash, :flash_danger_notify_tag, :flash_light_notify, to: :flash_info

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

  def twitter_card_tag(**options)
    provide(:twitter_card_tag, __twitter_card_tag(options))
  end

  def __twitter_card_tag(**options)
    options = {
      card: "summary_large_image",
      site: "@sgkinakomochi",
      title: AppConfig[:app_name],
      creator: "@sgkinakomochi",
      url: request.url,
      image: "apple-touch-icon.png",
    }.merge(options)

    o = []
    if v = options[:card]
      o << tag.meta(name: "twitter:card", content: v)
    end
    if v = options[:site]
      o << tag.meta(name: "twitter:site", content: v)
    end
    if v = options[:creator]
      o << tag.meta(name: "twitter:creator", content: v)
    end
    # twitter は投稿時に指定された URL を見ているだけで og:url や twitter:url を見ていない
    # if v = options[:url]
    #   o << tag.meta(name: "twitter:url", content: v)
    # end
    if v = options[:url]
      o << tag.meta(property: "og:url", content: v)
    end
    if v = options[:title]
      o << tag.meta(property: "og:title", content: v)
    end
    if v = options[:description]
      o << tag.meta(property: "og:description", content: v)
    end
    if v = options[:image]
      o << tag.meta(property: "og:image", content: image_url(v))
    end

    o.join.html_safe
  end
end
