import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MigrateInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        version: 20251125185039,
        up: context => {
          context.volume_common_user_scale  = 10
          context.volume_talk_user_scale    = 10
          context.volume_clock_user_scale   = 10
          context.volume_piece_user_scale = 10
        },
      },
    ]
  }
}
