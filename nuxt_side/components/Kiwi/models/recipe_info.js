import MemoryRecord from 'js-memory-record'

export class RecipeInfo extends MemoryRecord {
  static get field_label() {
    return "出力フォーマット"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      // ../../../app/models/recipe_info.rb
      { key: "is_recipe_mp4",  name: "MP4",  real_ext: "mp4",  loop_key_enable: false,  file_type: "video", environment: ["development", "staging", "production"], title: "一般的な動画形式",                  message: "◎Twitter ◎画質 ◎シーク ◎BGM", media_p: true,  thumbnail_p: true,  },
      { key: "is_recipe_gif",  name: "GIF",  real_ext: "gif",  loop_key_enable: true,   file_type: "image", environment: ["development", "staging", "production"], title: "一般的な画像切替形式",              message: "◎Twitter ◎画質 ×シーク",       media_p: true,  thumbnail_p: false, },
      { key: "is_recipe_apng", name: "APNG", real_ext: "apng", loop_key_enable: true,   file_type: "image", environment: ["development", "staging", "production"], title: "GIFの代替として注目されていた",     message: "×Twitter ◎画質 ×シーク",       media_p: true,  thumbnail_p: false, },
      { key: "is_recipe_webp", name: "WebP", real_ext: "webp", loop_key_enable: true,   file_type: "image", environment: ["development", "staging", "production"], title: "Googleだけが推している",            message: "×Twitter ◎画質 ×シーク",       media_p: true,  thumbnail_p: false, },
      { key: "is_recipe_png",  name: "PNG",  real_ext: "png",  loop_key_enable: false,  file_type: "image", environment: ["development", "staging", "production"], title: "最後の局面の画像",                  message: "1枚だけなので出来上がるのが速い", media_p: true,  thumbnail_p: false, },
      { key: "is_recipe_zip",  name: "ZIP",  real_ext: "zip",  loop_key_enable: false,  file_type: "zip",   environment: ["development", "staging", "production"], title: "PNG画像の詰め合わせ",               message: "自分で何かしたい人向け",          media_p: false, thumbnail_p: false, },
      // { key: "is_recipe_mov",             name: "MOV",               real_ext: "mov",  loop_key_enable: false, file_type: "video", environment: ["development"],                          message: "PC(WEB)から投稿できない。モバイルアプリから投稿できる",   },
      // { key: "is_recipe_jpg",             name: "JPG",               real_ext: "jpg",  loop_key_enable: false, file_type: "image", environment: ["development"],                          message: "最後の局面の画像",                                        },
      // { key: "is_recipe_bmp",             name: "BMP",               real_ext: "bmp",  loop_key_enable: false, file_type: "image", environment: ["development"],                          message: "最後の局面の画像",                                        },
      // { key: "is_recipe_mp4_yuv444p10le", name: "MP4 YUV444",        real_ext: "mp4",  loop_key_enable: false, file_type: "video", environment: ["development"],                          message: "PC(WEB)から投稿できない。モバイルアプリからは投稿できる", },
      // { key: "is_recipe_mp4_noopt",       name: "MP4 (noopt)",       real_ext: "mp4",  loop_key_enable: false, file_type: "video", environment: ["development"],                          message: "PC(WEB)から投稿できる。モバイルアプリからも投稿できる",   },
    ]
  }
}
