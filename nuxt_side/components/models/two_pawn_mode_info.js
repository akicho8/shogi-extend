import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TwoPawnModeInfo extends ApplicationMemoryRecord {
  static field_label = "二歩"
  static message = null

  static get define() {
    return [
      { key: "two_pawn_mode_allow",    name: "自由", message: "打てる",   },
      { key: "two_pawn_mode_disallow", name: "禁止", message: "打てない", },
    ]
  }
}
