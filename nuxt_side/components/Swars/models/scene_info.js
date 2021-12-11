import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SceneInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "critical", name: "開戦", board_show_p: true,  type: "is-primary", message: null, sp_turn_of: e => e.critical_turn, },
      { key: "outbreak", name: "中盤", board_show_p: true,  type: "is-primary", message: null, sp_turn_of: e => e.outbreak_turn, },
      { key: "last",     name: "終局", board_show_p: true,  type: "is-primary", message: null, sp_turn_of: e => e.turn_max,      },
    ]
  }

  get div_class() {
    return `is_scene_${this.key}`
  }
}
