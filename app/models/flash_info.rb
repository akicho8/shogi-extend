class FlashInfo
  cattr_accessor :notify_keys do
    [:default, :primary, :link, :info, :success, :warning, :danger]
  end

  cattr_accessor :tost_keys do
    notify_keys.collect { |e| "tost_#{e}".to_sym }
  end

  cattr_accessor :flash_all_keys do
    notify_keys + tost_keys
  end

  cattr_accessor :rails_default_keys do
    {
      "notice" => "success",
      "alert"  => "warning",
      "error"  => "danger",
    }
  end

  delegate :tag, :params, :flash, to: :view_context

  attr_accessor :view_context

  def initialize(view_context)
    @view_context = view_context

    if params[:debug]
      FlashInfo.flash_all_keys.each do |e|
        flash.now[e] = e.to_s
      end
    end
  end

  def normalized_flash
    @normalized_flash ||= flash.to_h.transform_keys do |e|
      e.to_s.sub(Regexp.union(rails_default_keys.keys), rails_default_keys).to_sym
    end
  end

  def flash_danger_notify_tag
    tag.div(:class => "content") do
      tag.p do
        tag.div(id: "flash_danger_notify_tag") do
          normalized_flash.slice(*notify_keys).collect { |key, message|
            content_tag("b-notification", message.html_safe, type: "is-#{key}", ":has-icon": "false", ":closable": "false")
          }.join.html_safe
        end
      end
    end
  end

  # 軽いもの success, info は toast で表示
  def flash_light_notify
    normalized_flash.slice(*tost_keys).transform_keys { |e| e.to_s.remove(/^tost_/) }
  end
end
