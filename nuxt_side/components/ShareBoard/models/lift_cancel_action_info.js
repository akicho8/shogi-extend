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
        message: "「将棋ウォーズ」や「ぴよ将棋」と同じ",
      },
      {
        key: "reality",
        name: "元の位置",
        type: "is-primary",
        message: "リアルと同じで元のセルに戻したら離す",
      },
      {
        key: "rehold",
        name: "持ち替え",
        type: "is-primary",
        message: "「lishogi」と同じ。離すことができない。別の駒をタップすればそのまま持ち替える。",
      },
    ]
  }
}
