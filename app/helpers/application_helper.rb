module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  def html_title
    [AppConfig[:app_name], @page_title].compact.reverse.join(" - ")
  end

  def bootstrap_flash
    flash.collect { |key, message|
      key = {notice: :success, alert: :danger, error: :danger}.fetch(key.to_sym) { key }
      close_button = content_tag(:button, raw("&times;"), key: "button", "class": "close", "data-dismiss": "alert")
      Array(message).collect do |e|
        content_tag(:div, close_button + e, "class": "alert fade in alert-#{key}")
      end
    }.flatten.compact.join("\n").html_safe
  end

  delegate :icon_tag, to: Fa

  def skill_option_create(e)
    str = e.name
    if v = e.alias_names.presence
      v = v.join("・")
      v = "（#{v}）"
      str = "#{str}#{v}"
    end
    {str => e.name}
  end
end
