# 使い方
#
# flash[:info]        = "..."  → b-notification(type="is-info")
# flash[:error]       = "..."  → b-notification(type="is-danger")    ※ error は buefy の danger に変換する
#
class FlashInfo
  # flash[:xxx] で使うキー
  # https://buefy.org/documentation/notification
  cattr_accessor :buefy_preset_types do
    [
      :white,
      :black,
      :light,
      :dark,
      :primary,
      :info,
      :success,
      :warning,
      :danger,
    ]
  end

  # Rails から Buefy のキーに置き換える
  cattr_accessor :rails_default_keys do
    {
      "notice" => :success,
      "alert"  => :warning,
      "error"  => :danger,
    }
  end

  cattr_accessor(:all_keys)   { buefy_preset_types }

  delegate :tag, :params, :flash, :content_tag, to: :view_context

  attr_accessor :view_context

  def initialize(view_context)
    @view_context = view_context

    if params[:debug]
      FlashInfo.all_keys.each do |e|
        flash.now[e] = e.to_s
      end
    end
  end

  def normalized_flash
    @normalized_flash ||= flash.to_h.transform_keys do |e|
      e.to_s.sub(Regexp.union(rails_default_keys.keys), rails_default_keys).to_sym
    end
  end

  # 危険通知は notification を使う
  def flash_notify_tag
    if list = normalized_flash.slice(*buefy_preset_types).presence
      tag.div(id: "flash_notify_tag") do
        list.collect { |key, message|
          content_tag("div", message.html_safe, class: "notification is-#{key}")
        }.join.html_safe
      end
    end
  end
end
