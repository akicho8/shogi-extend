import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class FactoryMethodInfo extends ApplicationMemoryRecord {
  static field_label = "mp4,gif,apng,webp 生成に用いるツール"
  static field_message = ""

  static get define() {
    return [
      { key: "is_factory_method_ffmpeg",   name: "ffmpeg",  type: "is-primary", message: "連番ファイルから生成。トータルでは遅いけど安定。メモリの少ないステージングでも確実に動作する", },
      { key: "is_factory_method_rmagick",  name: "rmagick", type: "is-primary", message: "mp4自力生成。しかし結局ffmpegでyuv420変換の必要あり。やや速いけどステージングではメモリが足りないせいか40手を超えるような棋譜はmp4生成の時点で何の例外も出さずに落ちる", },
    ]
  }
}
