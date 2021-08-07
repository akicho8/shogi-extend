import MemoryRecord from 'js-memory-record'

export class AnimationFormatInfo extends MemoryRecord {
  static get field_label() {
    return "変換フォーマット"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "gif",  name: "GIF",  type: "is-primary", message: "画質は粗いけどTwitter対応の一般的フォーマット",                 development_only: false, },
      { key: "webp", name: "WebP", type: "is-primary", message: "Twitter非対応だけど画質は良いGoogle考案のマイナーフォーマット", development_only: false, },
      { key: "apng", name: "APNG", type: "is-primary", message: "Twitter非対応だけど画質は良いマイナーフォーマット",             development_only: false, },
      { key: "mp4",  name: "MP4",  type: "is-primary", message: "Twitter非対応だけど再生しやすい",                               development_only: false, },
      { key: "mov",  name: "MOV",  type: "is-primary", message: "Twitter非対応のうえに再生しづらい",                             development_only: false, },
      { key: "png",  name: "PNG",  type: "is-primary", message: "動画生成の過程を経て画像化は何がしたいのかわからない",    development_only: false, },
      { key: "jpg",  name: "JPG",  type: "is-primary", message: "動画用のデータを準備して画像保存は非効率",                      development_only: true,  },
      { key: "bmp",  name: "BMP",  type: "is-primary", message: "動画用のデータを準備して画像保存は非効率",                      development_only: true,  },
    ]
  }
}
