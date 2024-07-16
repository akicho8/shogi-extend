import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ResponseStatusCodeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "code404", message: "ページが見つからないか権限がありません",                                                                                                                                 },
      { key: "code403", message: "権限がありません",                                                                                                                                                       },
      { key: "code400", message: "正しく処理できません",                                                                                                                                                   },
      { key: "code413", message: "ファイルサイズが大きすぎます。動画作成の場合は画像やBGMのサイズを合計で10MB以内にしてみてください (これは nginx の client_max_body_size の値が 10m なのに関係している)", },
      { key: "code502", message: "メモリ不足でサーバーが死にました。10秒ほど待つと復活するかもしれません。",                                                                                                 },
      { key: "code503", message: "ちょうど使っている最中にメンテになったのでぶっこわれました。とりあえずメンテ画面に移動します。",                                                                                                   },
    ]
  }

  static lookup_by_status_code(status_code) {
    return this.lookup(`code${status_code}`)
  }
}
