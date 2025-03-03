import { Gs } from '@/components/models/gs.js'
const MD5 = require("md5.js")

export class OsChange {
  constructor(context) {
    Gs.assert_kind_of_hash(context)
    this.context = context
    this.original_hash = this.current_hash
  }

  // 変更があるか？
  get has_changes_to_save_p() {
    return this.original_hash != this.current_hash
  }

  get message() {
    return `変更を適用しないまま閉じようとしています<br>適用するにはキャンセルして確定をタップしてください`
  }

  // デバッグ用
  get to_h() {
    return {
      original_hash: this.original_hash,
      current_hash: this.current_hash,
    }
  }

  // private

  get current_hash() {
    const str = JSON.stringify([
      this.context.order_unit.hash,
      [
        this.context.illegal_behavior_key,
        this.context.auto_resign_key,
        this.context.auto_resign2_key,
        this.context.change_per,
      ]
    ])
    return new MD5().update(str).digest("hex")
  }
}
