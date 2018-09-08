import MemoryRecord from 'js-memory-record'

export default class LifetimeInfo extends MemoryRecord {
  static get define() {
    return js_global.lifetime_infos
  }
}
