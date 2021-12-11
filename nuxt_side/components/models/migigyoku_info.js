import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MigigyokuInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "右玉",           },
      { key: "角換わり右玉",   },
      { key: "糸谷流右玉",     },
      { key: "羽生流右玉",     },
      { key: "ツノ銀型右玉",   },
      { key: "雁木右玉",       },
      { key: "矢倉右玉",       },
      { key: "三段右玉",       },
      { key: "清野流岐阜戦法", },
    ]
  }
}
