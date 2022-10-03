import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { isMobile } from "@/components/models/is_mobile.js"

export class PiyoShogiTypeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "auto",   name: "自動判別",   showable_p_fn: e => e.native_p, native_p_fn: () => isMobile.iOS() || isMobile.Android(), message: "スマホだけで「ぴよ将棋」を表示する", },
      { key: "native", name: "ぴよ将棋",   showable_p_fn: e => true,       native_p_fn: () => true,                                 message: "常に「ぴよ将棋」を使う",             },
      { key: "web",    name: "ぴよ将棋ｗ", showable_p_fn: e => true,       native_p_fn: () => false,                                message: "常に「ぴよ将棋ｗ」を使う",           },
    ]
  }

  // for PiyoShogiButton.vue
  get showable_p() {
    return this.showable_p_fn(this)
  }

  get native_p() {
    return this.native_p_fn()
  }
}
