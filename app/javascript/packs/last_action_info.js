import { MemoryRecord } from 'js-memory-record'

class LastActionInfo extends MemoryRecord {
  static get define() {
    return js_global_params.last_action_infos
  }
}

export { LastActionInfo }
