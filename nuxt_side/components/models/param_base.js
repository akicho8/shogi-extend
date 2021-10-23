import { ApplicationMemoryRecord } from './application_memory_record.js'
import { Gs } from './gs.js'

export class ParamBase extends ApplicationMemoryRecord {
  default_for(context) {
    Gs.__assert__(this.default || this.defaults)
    if (this.defaults) {
      Gs.__assert__(context.$config.STAGE, "context.$config.STAGE")
      return this.defaults[context.$config.STAGE] || this.defaults["production"]
    } else {
      return this.default
    }
  }
}
