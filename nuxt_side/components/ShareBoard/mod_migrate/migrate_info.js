import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MigrateInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        version: 20251125185039,
        up: context => {
          context.volume_common_user_scale = 10
          context.volume_talk_user_scale   = 10
          context.volume_clock_user_scale  = 10
          context.volume_piece_user_scale  = 10
        },
      },
      {
        version: 20260330185837,
        up: context => {
          context.image_size_key = "is_image_size_1600x1200"
        },
      },
      {
        version: 20260331000000,
        up: context => {
          context.image_size_key = "is_image_size_1080x810"
        },
      },
      {
        version: 20260424000000,
        up: context => {
          context.origin_mark_feature_p = true
        },
      },
    ]
  }
}
