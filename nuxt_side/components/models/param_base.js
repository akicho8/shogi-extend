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
    let v = null
    Gs.__assert__(this.default !== undefined || this.defaults !== undefined, `${this.key} の default と defaults が未定義`)
    if (this.defaults) {
      Gs.__assert__(context.$config.STAGE, "context.$config.STAGE")
      v = this.defaults[context.$config.STAGE] || this.defaults["production"]
    } else {
      Gs.__assert__(this.default !== undefined, `${this.key} の default が未定義`)
      v = this.default
    }

    // Hash の場合そのまま返してしまうと初期値が更新されてしまう
    // だから clone する必要がある
    if (this.type === "hash") {
      if (typeof v === "object") {
        v = {...v}
      }
    }

    return v
  }
}
