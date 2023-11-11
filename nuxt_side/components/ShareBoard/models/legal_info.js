import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class LegalInfo extends ApplicationMemoryRecord {
  static field_label = "将棋のルール"
  static field_message = "無視にすると禁じ手や手番の制約がなくなる。つまり自分の手番で相手の駒を操作できる。それを利用して後手のときも先手の駒を動かせばずっと先手側を操作できるので先手だけの囲いの手順の棋譜(SFENに限る)を作ったりするのが簡単になる。しかし反則のため他のアプリでは読めない棋譜になってしまう。URL に legal_key=loose を指定すると無視にした状態で開始する。"

  static get define() {
    return [
      { key: "strict", name: "遵守", type: "is-primary", message: null, },
      { key: "loose",  name: "無視", type: "is-danger",  message: null, },
    ]
  }
}
