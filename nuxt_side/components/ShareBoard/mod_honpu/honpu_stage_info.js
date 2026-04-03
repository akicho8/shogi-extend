import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class HonpuStageInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "hs_honpu_only",
        name: "本譜のみ",
        kifu_copy_message: "本譜をコピーしました",
        help_message: null,
        honpu_visible_p: true,
        return_to_honpu_p: false,
      },
      {
        key: "hs_branching",
        name: "本譜分岐",
        kifu_copy_message: "コピーしましたがこれは本譜ではありません",
        help_message: "棋譜が本譜から分岐しています (本譜が必要であれば本譜に戻してください)",
        honpu_visible_p: false,
        return_to_honpu_p: true,
      },
      {
        key: "hs_honpu_none",
        name: "本譜なし",
        kifu_copy_message: "コピーしました",
        help_message: null,
        honpu_visible_p: false,
        return_to_honpu_p: false,
      },
    ]
  }
}
