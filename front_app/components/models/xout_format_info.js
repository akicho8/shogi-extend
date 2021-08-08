import MemoryRecord from 'js-memory-record'

export class XoutFormatInfo extends MemoryRecord {
  static get field_label() {
    return "出力形式"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      // ../../../app/models/xout_format_info.rb
      { key: "is_format_gif",            name: "GIF",                  real_ext: "gif",  mime_group: "image", type: "is-primary", message: "Twitter対応の一般的フォーマット",                               development_only: false, },
      { key: "is_format_webp",           name: "WebP",                 real_ext: "webp", mime_group: "image", type: "is-primary", message: "Twitter非対応だけど画質は良いGoogle考案フォーマット",           development_only: false, },
      { key: "is_format_apng",           name: "APNG",                 real_ext: "apng", mime_group: "image", type: "is-primary", message: "Twitter非対応だけど画質は良いフォーマット",                     development_only: false, },
      { key: "is_format_mp4",            name: "MP4",                  real_ext: "mp4",  mime_group: "video", type: "is-primary", message: "PC(WEB)から投稿できない。モバイルアプリからは投稿できる",       development_only: false, },
      { key: "is_format_safe_mp4",       name: "MP4 (yuv420p)",        real_ext: "mp4",  mime_group: "video", type: "is-primary", message: "PC(WEB)から投稿できる。モバイルアプリからも投稿できる",         development_only: false, },
      { key: "is_format_safe_mp4_noopt", name: "MP4 (yuv420p, noopt)", real_ext: "mp4",  mime_group: "video", type: "is-primary", message: "PC(WEB)から投稿できる。モバイルアプリからも投稿できる",         development_only: false, },
      { key: "is_format_mov",            name: "MOV",                  real_ext: "mov",  mime_group: "video", type: "is-primary", message: "PC(WEB)から投稿できない。モバイルアプリから投稿できる",         development_only: false, },
      { key: "is_format_png",            name: "PNG",                  real_ext: "png",  mime_group: "image", type: "is-primary", message: "動画生成の過程を経て画像化は何がしたいのかわからない",          development_only: false, },
      { key: "is_format_jpg",            name: "JPG",                  real_ext: "jpg",  mime_group: "image", type: "is-primary", message: "動画生成の過程を経て画像化は何がしたいのかわからない",          development_only: true,  },
      { key: "is_format_bmp",            name: "BMP",                  real_ext: "bmp",  mime_group: "image", type: "is-primary", message: "動画生成の過程を経て画像化は何がしたいのかわからない",          development_only: true,  },
    ]
  }
}
