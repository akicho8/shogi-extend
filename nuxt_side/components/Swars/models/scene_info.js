import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SceneInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "critical_turn", name: "開戦", },
      { key: "outbreak_turn", name: "中盤", },
      { key: "turn_max",      name: "終局", },
    ]
  }

  get div_class() {
    return `is_scene_${this.key}`
  }

  sp_turn_of(context) {
    return context[this.key]
  }
}
