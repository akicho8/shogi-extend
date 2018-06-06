import { MemoryRecord } from 'js-memory-record'

class PlatoonInfo extends MemoryRecord {
  static get define() {
    return js_global_params.platoon_infos
  }
}

export { PlatoonInfo }
