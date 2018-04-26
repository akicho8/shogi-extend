module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  delegate :icon_tag, to: Fa

  def html_title
    [AppConfig[:app_name], @page_title].compact.reverse.join(" - ")
  end

  def legacy_types
    {
      notice: :success,
      alert: :warning,
      error: :danger,
    }
  end

  def tost_types
    [:success, :info]
  end

  def normalized_flash
    if params[:debug]
      flash.now[:info] = "(info)"
      flash.now[:danger] = "(danger)"
    end

    @normalized_flash ||= flash.to_h.transform_keys { |key| legacy_types.fetch(key.to_sym, key.to_sym) }
  end

  # success, info は toast で表示
  def flash_success_notifications
    normalized_flash.slice(*tost_types)
  end

  # :success, :info, :warning, :danger
  def flash_danger_notification_tag
    content_tag(:div, id: "flash_danger_notification_tag") do
      normalized_flash.except(*tost_types).collect { |key, message|
        content_tag("b-notification", message, type: "is-#{key}", ":has-icon": "false", ":closable": "true") + tag.br
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
