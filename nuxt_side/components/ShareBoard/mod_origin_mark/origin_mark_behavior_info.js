import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class OriginMarkBehaviorInfo extends ApplicationMemoryRecord {
  static field_label = "自分の移動元印を表示"
  static field_message = ""

  static get define() {
    return [
      {
        key: "omb_without_self",
        name: "しない",
        _if: (context, params) => !context.received_from_self(params),
      },
      {
        key: "omb_with_self",
        name: "する",
        _if: (context, params) => true,
      },
    ]
  }
}
