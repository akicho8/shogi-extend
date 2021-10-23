import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class ZipDlStructureInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "date", name: "対局日毎", message: "「ウォーズID/2020-01-01/ファイル」のような構造で格納する", },
      { key: "all",  name: "フラット", message: "「ウォーズID/ファイル」のような構造で格納する",            },
    ]
  }
}
