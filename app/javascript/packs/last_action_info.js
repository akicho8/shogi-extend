import MemoryRecord from 'js-memory-record'

export default class LastActionInfo extends MemoryRecord {
  static get define() {
    return js_global.last_action_infos
  }
}
