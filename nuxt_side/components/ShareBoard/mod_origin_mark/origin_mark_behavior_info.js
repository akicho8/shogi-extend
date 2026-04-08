import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class OriginMarkBehaviorInfo extends ApplicationMemoryRecord {
  static field_label = "移動元印の動作モード"
  static field_message = ""

  static get define() {
    return [
      {
        key: "omb_without_self",
        name: "自分以外の移動元印だけを見れる",
        _if: (context, params) => !context.received_from_self(params),
      },
      {
        key: "omb_with_self",
        name: "自分の移動元印も自分は見れる",
        _if: (context, params) => true,
      },
    ]
  }
}
