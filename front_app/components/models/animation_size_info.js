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
      { key: "is320x180",  name: "小",     width:  320, height: 180, type: "is-primary", message: "320x180",  },
      { key: "is640x360",  name: "中",     width:  640, height: 360, type: "is-primary", message: "640x360",  },
      { key: "is1200x630", name: "OGP",    width: 1200, height: 630, type: "is-primary", message: "1200x630", },
      { key: "is1280x720", name: "大(HD)", width: 1280, height: 720, type: "is-primary", message: "1280x720", },
    ]
  }
}
