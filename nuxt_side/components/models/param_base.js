import { ApplicationMemoryRecord } from "./application_memory_record.js"
import { GX } from "@/components/models/gx.js"
import _ from "lodash"

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
    GX.assert(this.default !== undefined || this.defaults !== undefined, `${this.key} の default と defaults が未定義`)
    if (this.defaults) {
      GX.assert(context.$config.STAGE, "context.$config.STAGE")
      v = this.defaults[context.$config.STAGE] ?? this.defaults["production"] // || では development の false が無視されてしまう
    } else {
      GX.assert(this.default !== undefined, `${this.key} の default が未定義`)
      v = this.default
    }

    // 初期値とする値が関数なら呼ぶ
    if (_.isFunction(v)) {
      v = v(context)
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
