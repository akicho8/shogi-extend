import MemoryRecord from 'js-memory-record'

export default class CustomPresetInfo extends MemoryRecord {
  static get define() {
    return js_global.custom_preset_infos
  }
}
