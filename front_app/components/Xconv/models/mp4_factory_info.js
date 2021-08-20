import MemoryRecord from 'js-memory-record'

export class Mp4FactoryInfo extends MemoryRecord {
  static get field_label() {
    return "mp4生成方法"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "ffmpeg",   name: "ffmpeg",  type: "is-primary", message: "連番ファイルから生成。トータルでは遅いけど安定", },
      { key: "rmagick",  name: "rmagick", type: "is-primary", message: "内部のリストからmp4生成。結局ffmpegでyuv420変換の必要あり。やや速いけどとても不安定", },
    ]
  }
}
