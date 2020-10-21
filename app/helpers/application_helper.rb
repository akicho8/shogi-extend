module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  delegate :icon_tag, to: Icon

  def html_title
    @override_page_title || full_html_title
  end

  def full_html_title
    titles = [AppConfig[:app_name], content_for(:page_title), @page_title]
    titles.flatten.reject(&:blank?).reverse.join(" | ")
  end

  concerning :FlashMethods do
    delegate :normalized_flash, :flash_notify_tag, to: :flash_info

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

  def ogp_params_set(options = {})
    @ogp_params = options
  end
end
