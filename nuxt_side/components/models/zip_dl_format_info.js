import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ZipDlFormatInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "kif",  message: "多くのソフトが対応している一般的な形式", },
      { key: "ki2",  message: "人間向けで掲示板に貼るのに向いている",   },
      { key: "csa",  message: "コンピュータ将棋用",                     },
      { key: "sfen", message: "コンピュータ将棋用の1行表記",            },
    ]
  }

  get name() {
    return this.key.toUpperCase()
  }
}
