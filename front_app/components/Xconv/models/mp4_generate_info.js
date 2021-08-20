import MemoryRecord from 'js-memory-record'

export class Mp4GenerateInfo extends MemoryRecord {
  static get field_label() {
    return "生成方法"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "ffmpeg",   name: "ffmpeg",  type: "is-primary", message: null, },
      { key: "rmagick",  name: "rmagick", type: "is-primary", message: null, },
    ]
  }
}
