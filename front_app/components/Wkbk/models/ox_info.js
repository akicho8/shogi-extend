import MemoryRecord from 'js-memory-record'

export class OxInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "o", name: "正解", icon: "circle-outline", type: "is-danger",  },
      { key: "x", name: "誤答", icon: "close",          type: "is-success", },
    ]
  }

  get icon_attrs() {
    return { icon: this.icon, type: this.type }
  }
}
