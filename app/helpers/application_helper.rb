module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  delegate :icon_tag, to: Fa

  def html_title
    @override_page_title || full_html_title
  end

  def full_html_title
    titles = [AppConfig[:app_name], content_for(:page_title), @page_title]
    titles.flatten.compact.reverse.join(" - ")
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

  def twitter_card_meta_tag(**options)
    options = {
      card: "summary_large_image",
      site: "@kinakom0chi",
      creator: "@kinakom0chi",
      url: request.url,
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

    provide(:head, o.join.html_safe)
  end
end
