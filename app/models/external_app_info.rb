class ExternalAppInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :piyo_shogi, name: "ぴよ将棋", shortcut_name: "直前開くぴよ", other_window: false, },
    { key: :kento,      name: "KENTO",    shortcut_name: "直前KENTO",    other_window: true,  }, # iOS Safari では other_window が効かない
  ]

  def apple_touch_icon
    "apple-touch-icon-#{key}.png"
  end

  def external_url(h, record)
    unless Rails.env.production?
      return "https://www.example.net/"
    end

    h.public_send("#{key}_app_url", h.full_url_for([record, format: "kif"]))
  end
end
