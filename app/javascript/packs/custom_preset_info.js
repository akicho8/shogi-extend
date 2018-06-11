import { MemoryRecord } from 'js-memory-record'

class CustomPresetInfo extends MemoryRecord {
  static get define() {
    return js_global_params.custom_preset_infos
  }
}

export { CustomPresetInfo }
