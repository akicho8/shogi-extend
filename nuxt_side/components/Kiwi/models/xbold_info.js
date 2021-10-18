import MemoryRecord from 'js-memory-record'

export class XboldInfo extends MemoryRecord {
  static get field_label() {
    return "駒書体の太さ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "is_xbold_auto", name: "おまかせ", type: "is-primary", message: "だいだい細字",                  },
      { key: "is_xbold_off",  name: "細い",     type: "is-primary", message: "あっさり (最後の指し手は太字)", },
      { key: "is_xbold_on",   name: "太い",     type: "is-primary", message: "こってり",                      },
    ]
  }
}
