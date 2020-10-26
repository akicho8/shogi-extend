import MemoryRecord from 'js-memory-record'

export class ExternalAppInfo extends MemoryRecord {
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
