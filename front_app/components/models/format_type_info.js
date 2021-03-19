import MemoryRecord from 'js-memory-record'

export class FormatTypeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "kif",           name: "KIF",             format_key: "kif",  body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "kif_shift_jis", name: "KIF (Shift_JIS)", format_key: "kif",  body_encode: "Shift_JIS", show: false, clipboard: false, },
      { key: "ki2",           name: "KI2",             format_key: "ki2",  body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "csa",           name: "CSA",             format_key: "csa",  body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "sfen",          name: "SFEN",            format_key: "sfen", body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "bod",           name: "BOD",             format_key: "bod",  body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "png",           name: "画像 (PNG)",      format_key: "png",  body_encode: "",          show: true,  clipboard: false, },
    ]
  }
}
