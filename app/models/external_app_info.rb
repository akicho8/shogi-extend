class ExternalAppInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :piyo_shogi, name: "ぴよ将棋", shortcut_name: "最新開くぴよ", },
    { key: :kento,      name: "KENTO",    shortcut_name: "最新KENTO",    },
  ]

  def apple_touch_icon
    "apple-touch-icon-#{key}.png"
  end

  def external_url(h, record)
    h.public_send("#{key}_app_url", h.full_url_for([record, format: "kif"]))
  end
end
