import MemoryRecord from "js-memory-record"

export class ZipDlStructureInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "date", name: "対局日毎", message: "「ウォーズID/2020-01-01/ファイル」のような構造で格納する", },
      { key: "all",  name: "フラット", message: "「ウォーズID/ファイル」のような構造で格納する",            },
    ]
  }
}
