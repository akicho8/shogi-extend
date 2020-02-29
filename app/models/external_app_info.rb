class ExternalAppInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :piyo_shogi, name: "ぴよ将棋", shortcut_name: "直前開くぴよ", redirect_in_controller: false, other_window: false, external_url_func: nil,                                             },
    { key: :kento,      name: "KENTO",    shortcut_name: "直前KENTO",    redirect_in_controller: true,  other_window: true,  external_url_func: -> h, record { h.kento_app_url_switch(record) }, }, # iOS Safari では other_window が効かない
  ]

  def apple_touch_icon
    "apple-touch-icon-#{key}.png"
  end

  def external_url(h, record)
    if func = external_url_func
      return func.call(h, record)
    end

    # デフォルトでは kif を渡す (kento_app_url, piyo_shogi_app_url)
    h.public_send("#{key}_app_url", h.full_url_for([record, format: "kif"]))
  end
end
