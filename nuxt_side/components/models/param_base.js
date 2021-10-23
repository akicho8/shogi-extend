import { ApplicationMemoryRecord } from "./application_memory_record.js"
import { Gs } from "./gs.js"

export class ParamBase extends ApplicationMemoryRecord {
  // 例
  //
  //   data() {
  //     return {
  //       ...FooInfo.null_value_data_hash,
  //     }
  //   },
  //
  static get null_value_data_hash() {
    return this.values.reduce((a, e) => ({...a, [e.key]: null}), {})
  }

  // default_for(this)
  default_for(context) {
    Gs.__assert__(this.default || this.defaults)
    if (this.defaults) {
      Gs.__assert__(context.$config.STAGE, "context.$config.STAGE")
      return this.defaults[context.$config.STAGE] || this.defaults["production"]
    } else {
      Gs.__assert__(this.default !== undefined, "this.default !== undefined")
      return this.default
    }
  }
}
