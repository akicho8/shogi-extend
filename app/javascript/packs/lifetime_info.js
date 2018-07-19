import { MemoryRecord } from 'js-memory-record'

class LifetimeInfo extends MemoryRecord {
  static get define() {
    return js_global.lifetime_infos
  }
}

export { LifetimeInfo }
