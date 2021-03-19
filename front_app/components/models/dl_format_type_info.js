import MemoryRecord from 'js-memory-record'

export class DlFormatTypeInfo extends MemoryRecord {
  static get define() {
    return [
      { name: "KIF",             format_key: "kif",  body_encode: "UTF-8",     },
      { name: "KIF (Shift_JIS)", format_key: "kif",  body_encode: "Shift_JIS", },
      { name: "KI2",             format_key: "ki2",  body_encode: "UTF-8",     },
      { name: "CSA",             format_key: "csa",  body_encode: "UTF-8",     },
      { name: "SFEN",            format_key: "sfen", body_encode: "UTF-8",     },
      { name: "BOD",             format_key: "bod",  body_encode: "UTF-8",     },
      { name: "画像 (PNG)",      format_key: "png",  body_encode: "",          },
    ]
  }
}
