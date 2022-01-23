import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SpInternalRuleInfo extends ApplicationMemoryRecord {
  static field_label = "将棋のルールを"
  static field_message = "無視にすると「自分の手番では自分の駒を操作する」の制約を無視する。そのため自分の手番で相手の駒を操作できる。それを利用して後手のときも先手の駒を動かせばずっと先手側を操作できるので先手だけの囲いの手順の棋譜(SFENに限る)を作ったりするのが簡単になる。しかし反則のため他のアプリでは読めない棋譜になってしまう。この設定は無視にしたときだけURLに含む"

  static get define() {
    return [
      { key: "is_internal_rule_strict", name: "遵守", type: "is-primary", message: null, },
      { key: "is_internal_rule_free",   name: "無視", type: "is-danger",  message: null, },
    ]
  }
}
