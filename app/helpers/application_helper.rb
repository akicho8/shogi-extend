module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  delegate :icon_tag, to: Fa

  def html_title
    [AppConfig[:app_name], @page_title].compact.reverse.join(" - ")
  end

  # :success, :info, :warning, :danger
  def app_notification_tag
    legacy_types = {
      notice: :success,
      alert: :warning,
      error: :danger,
    }

    if params[:debug]
      flash.now[:info] = "(info)"
      flash.now[:danger] = "(danger)"
    end

    content_tag(:div, id: "app_notification_tag") do
      flash.collect { |key, message|
        key = legacy_types.fetch(key.to_sym) { key }
        content_tag("b-notification", message, type: "is-#{key}", ":has-icon": "false", ":closable": "false") + tag.br
      }.join.html_safe
    end
  end

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
