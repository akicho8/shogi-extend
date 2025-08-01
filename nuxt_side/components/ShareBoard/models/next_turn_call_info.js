import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class NextTurnCallInfo extends ApplicationMemoryRecord {
  static field_label = "手番のお知らせ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_next_turn_call_on",  name: "する",   type: "is-primary", message: "3人以上で対局しているとき「次は○○さんの手番です」と伝える。自分の手番がわからなくなる人向け。", },
      { key: "is_next_turn_call_off", name: "しない", type: "is-warning", message: "静かにする (主に観戦者として実況したいとき用)", },
    ]
  }
}
