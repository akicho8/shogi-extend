import MemoryRecord from "js-memory-record"

export default class BoardStyleInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "p", name: "紙面風",       func: praams => { praams.theme = 'simple' },                           },
      { key: "a", name: "普通駒",       func: praams => { praams.theme = 'real'; praams.piece_variant = 'a' }, },
      { key: "b", name: "図案駒",       func: praams => { praams.theme = 'real'; praams.piece_variant = 'b' }, },
      { key: "c", name: "以前の図案駒", func: praams => { praams.theme = 'real'; praams.piece_variant = 'c' }, },
    ]
  }
}
