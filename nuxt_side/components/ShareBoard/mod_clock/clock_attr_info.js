import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import _ from "lodash"

export class ClockAttrInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "initial_main_min",  name: "持ち時間",  min: 0, max: 60, th_label: "持ち時間(分)",        unit: "分", tooltip: "秒読みに入る前の持ち時間です",                      },
      { key: "initial_read_sec",  name: "秒読み",    min: 0, max: 60, th_label: "秒読み",              unit: "秒", tooltip: "毎回、全回復する持ち時間です",                      },
      { key: "initial_extra_min", name: "考慮時間",  min: 0, max: 60, th_label: "考慮時間<b>(分)</b>", unit: "分", tooltip: "秒読みが切れた後の持ち時間です",                    },
      { key: "every_plus",        name: "1手毎加算", min: 0, max: 60, th_label: "1手毎加算(秒)",       unit: "秒", tooltip: "フィッシャールール用で1手ごと持ち時間に加算します", },
    ]
  }

  validate_message(params) {
    const value = params[this.key]
    if (value > this.max) {
      return `${this.name}は${this.max}${this.unit}以内にしよう`
    }
    if (value < this.min) {
      return `${this.name}は${this.min}${this.unit}以上にしよう`
    }
  }
}
