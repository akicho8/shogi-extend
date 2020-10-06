# 使い方
#
# flash[:info]        = "..."  → b-notification(type="is-info")
# flash[:toast_info]  = "..."  → $buefy.toast.open(type="is-info")
# flash[:error]       = "..."  → b-notification(type="is-danger")    ※ error は buefy の danger に変換する
# flash[:toast_error] = "..."  → $buefy.toast.open(type="is-danger") ※ error は buefy の danger に変換する
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

  cattr_accessor(:toast_keys) { buefy_preset_types.collect { |e| "toast_#{e}".to_sym } }
  cattr_accessor(:all_keys)   { buefy_preset_types + toast_keys }

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
  def flash_danger_notify_tag
    if list = normalized_flash.slice(*buefy_preset_types).presence
      tag.div(id: "flash_danger_notify_tag") do
        list.collect { |key, message|
          content_tag("div", message.html_safe, class: "notification is-#{key}")
        }.join.html_safe
      end
    end
  end

  # toast_ で始まるキーをあつめて toast_ を取る
  def toast_flash
    normalized_flash.slice(*toast_keys).transform_keys { |e| e.to_s.remove(/^toast_/) }
  end
end
