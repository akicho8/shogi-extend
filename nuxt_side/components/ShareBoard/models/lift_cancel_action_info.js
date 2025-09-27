import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class LiftCancelActionInfo extends ApplicationMemoryRecord {
  static field_label = "持ち上げた駒をいったん元に戻すのはどこをタップしたとき？"
  static field_message = "右クリックやESCキーでもキャンセルできる"

  static get define() {
    return [
      {
        key: "standard",
        name: "移動先以外",
        type: "is-primary",
        message: "将棋ウォーズや、ぴよ将棋と同じ",
      },
      {
        key: "reality",
        name: "元の位置",
        type: "is-warning",
        message: "リアル対局と同じで元の升目に戻したとき",
      },
      {
        key: "rehold",
        name: "持ち替える",
        type: "is-danger",
        message: "lishogi と同じで戻せない。別の駒をタップすればそのまま持ち替える。",
      },
    ]
  }
}
