import MemoryRecord from 'js-memory-record'

export class SpInternalRuleInfo extends MemoryRecord {
  static field_label = "将棋のルール"
  static field_message = "無視にすると「自分の手番では自分の駒を操作する」の制約を無視する。そのため自分の手番で相手の駒を操作できる。それを利用して後手のときも先手の駒を動かせばずっと先手側を操作できるので先手だけの囲いの手順の棋譜を作ったりするのが簡単になる。しかし反則のため他のアプリでは読めない棋譜になってしまう。この設定は無視にしたときだけURLに含む"

  static get define() {
    return [
      { key: "is_internal_rule_strict", name: "守る", type: "is-primary", message: null, },
      { key: "is_internal_rule_free",   name: "無視", type: "is-danger",  message: null, },
    ]
  }
}
