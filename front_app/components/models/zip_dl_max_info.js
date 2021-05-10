import MemoryRecord from "js-memory-record"

export class ZipDlMaxInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "1",  name: "1",  value: 1,  message: "1件なら対局詳細からダウンロードした方がZIPにならないぶん簡単です", },
      { key: "50", name: "50", value: 50, message: "51件以上取得したいときは「古い棋譜を補完」のほうを使ってください", },
    ]
  }
}
