import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import _ from "lodash"

export class ClockAttrInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "initial_main_min",  name: "持ち時間",  max: 60,   th_label: "持ち時間(分)",        tooltip: "秒読みに入る前の持ち時間です",                                                                       },
      { key: "initial_read_sec",  name: "秒読み",    max: 60*5, th_label: "秒読み",              tooltip: "毎回、全回復する持ち時間です",                                                                       },
      { key: "initial_extra_min", name: "考慮時間",  max: 60,   th_label: "考慮時間<b>(分)</b>", tooltip: "秒読みが切れた後の持ち時間です<br>勝負どころのための時間であり、切れ負け防止用の猶予ではありません", },
      { key: "every_plus",        name: "1手毎加算", max: 60,   th_label: "1手毎加算(秒)",       tooltip: "フィッシャールール用で1手ごと持ち時間に加算します",                                                  },
    ]
  }
}
