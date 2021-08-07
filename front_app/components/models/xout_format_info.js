import MemoryRecord from 'js-memory-record'

export class XoutFormatInfo extends MemoryRecord {
  static get field_label() {
    return "変換フォーマット"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "is_format_gif",         name: "GIF",           real_ext: "gif",  mime_group: "image", type: "is-primary", message: "画質は粗いけどTwitter対応の一般的フォーマット",                 development_only: false, },
      { key: "is_format_webp",        name: "WebP",          real_ext: "webp", mime_group: "image", type: "is-primary", message: "Twitter非対応だけど画質は良いGoogle考案のマイナーフォーマット", development_only: false, },
      { key: "is_format_apng",        name: "APNG",          real_ext: "apng", mime_group: "image", type: "is-primary", message: "Twitter非対応だけど画質は良いマイナーフォーマット",             development_only: false, },
      { key: "is_format_mp4",         name: "MP4",           real_ext: "mp4",  mime_group: "video", type: "is-primary", message: "Twitter非対応だけど再生しやすい",                               development_only: false, },
      { key: "is_format_mp4_yuv420p", name: "MP4 (yuv420p)", real_ext: "mp4",  mime_group: "video", type: "is-primary", message: "Twitter非対応だけど再生しやすい",                               development_only: false, },
      { key: "is_format_mov",         name: "MOV",           real_ext: "mov",  mime_group: "video", type: "is-primary", message: "Twitter非対応のうえに再生しづらい",                             development_only: false, },
      { key: "is_format_png",         name: "PNG",           real_ext: "png",  mime_group: "image", type: "is-primary", message: "動画生成の過程を経て画像化は何がしたいのかわからない",    development_only: false, },
      { key: "is_format_jpg",         name: "JPG",           real_ext: "jpg",  mime_group: "image", type: "is-primary", message: "動画用のデータを準備して画像保存は非効率",                      development_only: true,  },
      { key: "is_format_bmp",         name: "BMP",           real_ext: "bmp",  mime_group: "image", type: "is-primary", message: "動画用のデータを準備して画像保存は非効率",                      development_only: true,  },
    ]
  }
}
