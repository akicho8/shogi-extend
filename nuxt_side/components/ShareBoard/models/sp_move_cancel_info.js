import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SpMoveCancelInfo extends ApplicationMemoryRecord {
  static field_label = "どこをタップしたら持った駒を離すか"
  static field_message = "右クリックやESCキーでもキャンセルできる"

  static get define() {
    return [
      { key: "is_move_cancel_standard", name: "移動先以外", type: "is-primary", message: "将棋ウォーズやぴよ将棋はこれ。右クリックやESCキーでもキャンセルできる", },
      { key: "is_move_cancel_reality",  name: "元の位置",   type: "is-primary", message: "従来の方法。リアルで指すのと同様に元の位置に戻す。そうしてほしかった。しかし、有名アプリの影響で順応できない者が多かったため、仕方なく初期値を変更した。右クリックやESCキーでもキャンセルできる", },
    ]
  }
}
