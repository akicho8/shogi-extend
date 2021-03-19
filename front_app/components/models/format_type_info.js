import MemoryRecord from 'js-memory-record'

export class FormatTypeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "kif",  name: "KIF",        clipboard_copyable: true,  },
      { key: "ki2",  name: "KI2",        clipboard_copyable: true,  },
      { key: "csa",  name: "CSA",        clipboard_copyable: true,  },
      { key: "sfen", name: "SFEN",       clipboard_copyable: true,  },
      { key: "bod",  name: "BOD",        clipboard_copyable: true,  },
      { key: "png",  name: "画像 (PNG)", clipboard_copyable: false, },
    ]
  }

  get format_key() {
    return this.key
  }
}
