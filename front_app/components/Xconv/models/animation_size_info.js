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
      { key: "is320x240",   name: "× Quarter VGA",  width:  320, height: 240,  type: "is-primary", message: "やめといた方がいい", },
      { key: "is640x480",   name: "△ VGA",          width:  640, height: 480,  type: "is-primary", message: null,   },
      { key: "is720x540",   name: "？ 720x540",      width:  720, height: 540,  type: "is-primary", message: "両方720px以下ならエンコードされない？", },
      { key: "is960x720",   name: "？ 960x720",      width:  960, height: 720,  type: "is-primary", message: "短い方が720px以下ならエンコードされないらしい(本当？)", },
      { key: "is800x600",   name: "○ SVGA",         width:  800, height: 600,  type: "is-primary", message: null,   },
      { key: "is1024x768",  name: "◎ XGA",          width: 1024, height: 768,  type: "is-primary", message: null,   },
      { key: "is1200x630",  name: "△ OGP Image",    width: 1200, height: 630,  type: "is-primary", message: "無駄に横長になるのでおすすめしないがOGP画像の推奨サイズと合わせたいときに有用", },
      { key: "is1280x960",  name: "◎ Quad VGA",     width: 1280, height: 960,  type: "is-primary", message: null,   },
      { key: "is1280x720",  name: "○ HD",           width: 1280, height: 720,  type: "is-primary", message: "推奨と書いているサイトもある",   },
      { key: "is1600x1200", name: "△ UXGA",         width: 1600, height: 1200, type: "is-primary", message: "無駄にでかいので時間がかかる。SNS投稿するならここまででかくなくてもよい",       },
      // { key: "is3200x2400", name: "QUXGA 4:3",     width: 3200, height: 2400, type: "is-primary", message: null,  },
    ]
  }
}
