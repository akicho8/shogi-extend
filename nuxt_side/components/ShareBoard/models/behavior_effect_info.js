import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BehaviorEffectInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "kill_attack",      name: "殺した",           },
      { key: "move_or_appear",   name: "移動または打った", },
      { key: "killed_and_death", name: "殺された",         },
    ]
  }
}
