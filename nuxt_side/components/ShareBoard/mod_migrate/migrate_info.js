import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MigrateInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        // version: 20251125185036,
        // up: context => {
        //   if (
        //     true &&
        //       context.common_volume_scale  <= 5 &&
        //       context.talk_volume_scale    <= 5 &&
        //       context.clock_volume_scale   <= 5 &&
        //       context.komaoto_volume_scale <= 5 &&
        //       true) {
        //     context.common_volume_scale *= 2
        //     context.talk_volume_scale *= 2
        //     context.clock_volume_scale *= 2
        //     context.komaoto_volume_scale *= 2
        //   }
        // },
      },
    ]
  }
}
