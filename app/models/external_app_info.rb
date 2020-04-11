class ExternalAppInfo
  include Rails.application.routes.url_helpers
  include ApplicationMemoryRecord
  memory_record [
    { key: :piyo_shogi, name: "ぴよ将棋", shortcut_name: "直前開くぴよ", redirect_in_controller: false, other_window: false, },
    { key: :kento,      name: "KENTO",    shortcut_name: "直前KENTO",    redirect_in_controller: true,  other_window: true,  }, # iOS Safari では other_window が効かない
  ]

  def apple_touch_icon
    "apple-touch-icon-#{key}.png"
  end

  def external_url(record)
    h = Rails.application.routes.url_helpers

    m = "#{key}_app_url"
    if record.respond_to?(m)
      return record.public_send(m)
    end

    h.public_send(m, h.full_url_for([record, format: "kif"]))
  end
end
