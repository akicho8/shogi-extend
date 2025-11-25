import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MigrateInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        version: 20251125185039,
        up: context => {
          context.common_volume_scale  = 10
          context.talk_volume_scale    = 10
          context.clock_volume_scale   = 10
          context.komaoto_volume_scale = 10
        },
      },
    ]
  }
}
