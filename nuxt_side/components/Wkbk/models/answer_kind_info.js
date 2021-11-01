import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AnswerKindInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "correct", name: "正解",   sound_key: "o", name: "正解", icon: "circle-outline", type: "is-danger",  },
      { key: "mistake", name: "不正解", sound_key: "x", name: "誤答", icon: "close",          type: "is-success", },
    ]
  }

  get icon_attrs() {
    return { icon: this.icon, type: this.type }
  }
}
