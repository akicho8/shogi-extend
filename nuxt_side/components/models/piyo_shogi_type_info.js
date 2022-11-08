import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { MyMobile } from "@/components/models/my_mobile.js"

export class PiyoShogiTypeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "auto",   name: "自動判別",   showable_p_fn: e => e.native_p, native_p_fn: () => MyMobile.mobile_p, message: "スマホだけで「ぴよ将棋」を表示する", },
      { key: "native", name: "ぴよ将棋",   showable_p_fn: e => true,       native_p_fn: () => true,              message: "常に「ぴよ将棋」を使う",             },
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
