import MemoryRecord from 'js-memory-record'

export class FactoryMethodInfo extends MemoryRecord {
  static get field_label() {
    return "mp4,gif,apng,webp 生成に用いるツール"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "ffmpeg",   name: "ffmpeg",  type: "is-primary", message: "連番ファイルから生成。トータルでは遅いけど安定。メモリの少ないステージングでも確実に動作する", },
      { key: "rmagick",  name: "rmagick", type: "is-primary", message: "mp4自力生成。しかし結局ffmpegでyuv420変換の必要あり。やや速いけどステージングではメモリが足りないせいか40手を超えるような棋譜はmp4生成の時点で何の例外も出さずに落ちる", },
    ]
  }
}
