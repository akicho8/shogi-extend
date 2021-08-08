import MemoryRecord from 'js-memory-record'

export class AnimationSizeInfo extends MemoryRecord {
  static get field_label() {
    return "サイズ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      // https://ja.wikipedia.org/wiki/%E7%94%BB%E9%9D%A2%E8%A7%A3%E5%83%8F%E5%BA%A6
      { key: "is320x240",  name: "Quarter VGA 4:3",  width:  320, height: 240, type: "is-primary", message: "320x240",  },
      { key: "is640x480",  name: "VGA 4:3",          width:  640, height: 480, type: "is-primary", message: "640x480",  },
      { key: "is800x600",  name: "SVGA 4:3",         width:  800, height: 600, type: "is-primary", message: "800x600",  },
      { key: "is1024x768",  name: "XGA 4:3",         width:  1024, height: 768, type: "is-primary", message: "1024x768",  },
      { key: "is1200x630", name: "OGP Image 1.91:1", width: 1200, height: 630, type: "is-primary", message: "1200x630", },
      // { key: "is1280x720", name: "HD 16:9",       width: 1280, height: 720, type: "is-primary", message: "1280x720", },
      { key: "is1280x960", name: "Quad VGA 4:3",     width: 1280, height: 960, type: "is-primary", message: "1280x960", },
      { key: "is1600x1200", name: "UXGA 4:3",        width: 1600, height: 1200, type: "is-primary", message: "1600x1200", },
      { key: "is3200x2400", name: "QUXGA 4:3",       width: 3200, height: 2400, type: "is-primary", message: "3200x2400", },
    ]
  }
}
