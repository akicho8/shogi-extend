import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class NextTurnCallInfo extends ApplicationMemoryRecord {
  static field_label = "手番の通知"
  static field_message = ""

  static get define() {
    return [
      { key: "is_next_turn_call_on",  name: "する",   type: "is-primary", message: "3人以上で対局しているとき「次は○○さんの手番です」と伝える。リレー将棋初心者向け。配信では視聴者の状況把握を助ける。", },
      { key: "is_next_turn_call_off", name: "しない", type: "is-warning", message: "3人以上で対局していても手番を伝えない。リレー将棋に慣れている人向け。", },
    ]
  }
}
