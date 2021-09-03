import MemoryRecord from 'js-memory-record'

export class AnimationSizeInfo extends MemoryRecord {
  static get field_label() {
    return "サイズ"
  }

  // 未使用
  static get field_message() {
    return ""
  }

  static get define() {
    return [
      // https://ja.wikipedia.org/wiki/%E7%94%BB%E9%9D%A2%E8%A7%A3%E5%83%8F%E5%BA%A6
      { key: "is854x480",   name: "480p",           aspect_ratio: "16:9",   icon: "youtube", type: "is-danger", recommend: "◎", general_name: "FULL HD",     width: 854, height: 480,    type: "is-primary", environment: ["development", "staging", "production"], message: "動画サイト向け 低画質", },
      { key: "is1280x720",  name: "720p",           aspect_ratio: "16:9",   icon: "youtube", type: "is-danger", recommend: "◎", general_name: "HD",          width: 1280, height:  720,  type: "is-primary", environment: ["development", "staging", "production"], message: "動画サイト向け 一般的", },
      { key: "is1920x1080", name: "1080p",          aspect_ratio: "16:9",   icon: "youtube", type: "is-danger", recommend: "◎", general_name: "FULL HD",     width: 1920, height: 1080,  type: "is-primary", environment: ["development", "staging", "production"], message: "動画サイト向け 高画質", },
      { separator: true },
      { key: "is320x240",   name: "320x240",        aspect_ratio: "4:3",    icon: "rss",     type: "is-orange", recommend: "×", general_name: "Quarter VGA", width:  320, height:  240,  type: "is-primary", environment: ["development",                        ], message: "フォント呆け",          },
      { key: "is640x480",   name: "640x480",        aspect_ratio: "4:3",    icon: "rss",     type: "is-orange", recommend: "×", general_name: "VGA",         width:  640, height:  480,  type: "is-primary", environment: ["development",                        ], message: "フォント呆け",          },
      { key: "is720x540",   name: "720x540",        aspect_ratio: "4:3",    icon: "rss",     type: "is-orange", recommend: "○", general_name: "",            width:  720, height:  540,  type: "is-primary", environment: ["development", "staging", "production"], message: "ブログ向け",            },
      { key: "is800x600",   name: "800x600",        aspect_ratio: "4:3",    icon: "rss",     type: "is-orange", recommend: "○", general_name: "SVGA",        width:  800, height:  600,  type: "is-primary", environment: ["development", "staging", "production"], message: "ブログ向け",            },
      { key: "is960x720",   name: "960x720",        aspect_ratio: "4:3",    icon: "rss",     type: "is-orange", recommend: "○", general_name: "",            width:  960, height:  720,  type: "is-primary", environment: ["development", "staging", "production"], message: "ブログ向け",            },
      { key: "is1024x768",  name: "1024x768",       aspect_ratio: "4:3",    icon: "rss",     type: "is-orange", recommend: "○", general_name: "XGA",         width: 1024, height:  768,  type: "is-primary", environment: ["development", "staging", "production"], message: null,                    },
      { key: "is1280x960",  name: "1280x960",       aspect_ratio: "4:3",    icon: "rss",     type: "is-orange", recommend: "○", general_name: "Quad VGA",    width: 1280, height:  960,  type: "is-primary", environment: ["development", "staging", "production"], message: null,                    },
      { key: "is1600x1200", name: "1600x1200",      aspect_ratio: "4:3",    icon: "rss",     type: "is-orange", recommend: "○", general_name: "UXGA",        width: 1600, height: 1200,  type: "is-primary", environment: ["development", "staging", "production"], message: "",                      },
      { separator: true },
      { key: "is1200x630",  name: "1200x630",       aspect_ratio: "1.91:1", icon: "image",   type: "is-orange", recommend: "△", general_name: "OGP",         width: 1200, height:  630,  type: "is-primary", environment: ["development", "staging", "production"], message: "OGP画像サイズ",         },
      { separator: true },
      { key: "is_custom",   name: "ユーザー指定",   aspect_ratio: null,     icon: "cog",     type: "is-orange", recommend: null, general_name: null,          width: null, height: null,  type: "is-primary", environment: ["development", "staging", "production"], message: null,                    },
      // { key: "is3200x2400", name: "QUXGA 4:3", icon: "rss", type: "is-orange", recommend: "×", general_name: "QUXGA",       width: 3200, height: 2400, type: "is-primary", message: null,  },
    ]
  }

  get option_name() {
    if (this.key === "is_custom") {
      return this.name
    } else {
      // return `${this.type: "is-orange", recommend} ${this.name} (${this.aspect_ratio})`
      return `${this.name} (${this.aspect_ratio})`
    }
  }
}
