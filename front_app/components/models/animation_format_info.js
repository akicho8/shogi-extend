import MemoryRecord from 'js-memory-record'

export class AnimationFormatInfo extends MemoryRecord {
  static get field_label() {
    return "変換先フォーマット"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "gif",  name: "GIF",  type: "is-primary", message: "", },
      { key: "webp", name: "WEBP", type: "is-primary", message: "", },
      { key: "apng", name: "APNG", type: "is-primary", message: "", },
      { key: "png",  name: "PNG",  type: "is-primary", message: "", },
      { key: "jpg",  name: "JPG",  type: "is-primary", message: "", },
      { key: "bmp",  name: "BMP",  type: "is-primary", message: "", },
    ]
  }
}
