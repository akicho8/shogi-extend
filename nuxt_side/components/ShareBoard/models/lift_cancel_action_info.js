import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class LiftCancelActionInfo extends ApplicationMemoryRecord {
  static field_label = "どこをタップしたら持った駒を離すか"
  static field_message = "右クリックやESCキーでもキャンセルできる"

  static get define() {
    return [
      {
        key: "standard",
        name: "移動先以外",
        type: "is-primary",
        message: "将棋ウォーズ・ぴよ将棋に準拠する",
      },
      {
        key: "reality",
        name: "元の位置",
        type: "is-primary",
        message: "リアル風。元の位置に戻す",
      },
      {
        key: "rehold",
        name: "持ち替え",
        type: "is-primary",
        message: "lishogi準拠。離さず持ち替える",
      },
    ]
  }
}
