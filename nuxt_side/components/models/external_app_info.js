import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ExternalAppInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "piyo_shogi", name: "ぴよ将棋", shortcut_name: "直前開くぴよ", redirect_in_controller: false, other_window: false, },
      { key: "kento",      name: "KENTO",    shortcut_name: "直前KENTO",    redirect_in_controller: true,  other_window: true,  },
    ]
  }

  get apple_touch_icon() {
    return "apple-touch-icon-#{key}.png"
  }
}
