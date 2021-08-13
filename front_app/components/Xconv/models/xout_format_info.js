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
      { key: "is_format_mp4_yuv420",      name: "MP4",               real_ext: "mp4",  respond_html_tag: "video", environment: ["development", "staging", "production"], type: "is-primary", message: "◎Twitter ◎画質 ◎シーク",                               },
      { key: "is_format_gif",             name: "GIF",               real_ext: "gif",  respond_html_tag: "image", environment: ["development", "staging", "production"], type: "is-primary", message: "◎Twitter ◎画質 ×シーク",                               },
      { key: "is_format_png",             name: "PNG",               real_ext: "png",  respond_html_tag: "image", environment: ["development", "staging", "production"], type: "is-primary", message: "◎Twitter ◎画質 ※最後の局面の画像",                     },
      { key: "is_format_webp",            name: "WebP",              real_ext: "webp", respond_html_tag: "image", environment: ["development", "staging", "production"], type: "is-primary", message: "×Twitter ◎画質 ×シーク",                               },
      { key: "is_format_apng",            name: "APNG",              real_ext: "apng", respond_html_tag: "image", environment: ["development", "staging", "production"], type: "is-primary", message: "×Twitter ◎画質 ×シーク",                               },
      { key: "is_format_mov",             name: "MOV",               real_ext: "mov",  respond_html_tag: "video", environment: ["development"],                          type: "is-primary", message: "PC(WEB)から投稿できない。モバイルアプリから投稿できる",   },
      { key: "is_format_jpg",             name: "JPG",               real_ext: "jpg",  respond_html_tag: "image", environment: ["development"],                          type: "is-primary", message: "最後の局面の画像",                                        },
      { key: "is_format_bmp",             name: "BMP",               real_ext: "bmp",  respond_html_tag: "image", environment: ["development"],                          type: "is-primary", message: "最後の局面の画像",                                        },
      { key: "is_format_mp4_yuv444p10le", name: "MP4 YUV444",        real_ext: "mp4",  respond_html_tag: "video", environment: ["development"],                          type: "is-primary", message: "PC(WEB)から投稿できない。モバイルアプリからは投稿できる", },
      { key: "is_format_mp4_noopt",       name: "MP4 (noopt)",       real_ext: "mp4",  respond_html_tag: "video", environment: ["development"],                          type: "is-primary", message: "PC(WEB)から投稿できる。モバイルアプリからも投稿できる",   },
    ]
  }
}
