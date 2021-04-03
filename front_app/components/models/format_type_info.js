import MemoryRecord from 'js-memory-record'

export class FormatTypeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "kif",           name_fn: (t) => `KIF`,              format_key: "kif",  body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "kif_shift_jis", name_fn: (t) => `KIF (Shift_JIS)`,  format_key: "kif",  body_encode: "Shift_JIS", show: false, clipboard: false, },
      { key: "ki2",           name_fn: (t) => `KI2`,              format_key: "ki2",  body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "csa",           name_fn: (t) => `CSA`,              format_key: "csa",  body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "sfen",          name_fn: (t) => `SFEN`,             format_key: "sfen", body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "bod",           name_fn: (t) => `BOD #${t}`,        format_key: "bod",  body_encode: "UTF-8",     show: true,  clipboard: true,  },
      { key: "png",           name_fn: (t) => `画像 #${t}`,       format_key: "png",  body_encode: "",          show: true,  clipboard: false, },
    ]
  }
}
