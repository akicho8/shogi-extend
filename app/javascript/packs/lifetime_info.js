import { MemoryRecord } from 'js-memory-record'

class LifetimeInfo extends MemoryRecord {
  static get define() {
    return Object.values(Object.values(js_global_params.lifetime_info_hash))
  }
}

// LifetimeInfo.lookup("lifetime3_min")

export { LifetimeInfo }
