import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { MyMobile } from "@/components/models/my_mobile.js"

export class PiyoShogiTypeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "auto",   name: "自動", showable_p_fn: e => e.native_p, native_p_fn: () => MyMobile.mobile_p, message: "スマホだけで「ぴよ将棋」を表示する (デフォルト)", },
      { key: "native", name: "常時", showable_p_fn: e => true,       native_p_fn: () => true,              message: "Mac で「ぴよ将棋」を使う。スマホアプリの「ぴよ将棋」を Mac 上で動かせるようにしている上級者向け。", },
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
