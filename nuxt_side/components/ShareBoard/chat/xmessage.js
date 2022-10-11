// |---------------------|
// | message             |
// | auto_linked_message |
// | from_connection_id  |
// | from_user_name      |
// | unique_key          |
// | toast_params        |
// | css_class           |
// |---------------------|

import { Gs2 } from "@/components/models/gs2.js"
import { TimeUtil } from "@/components/models/time_util.js"
import { MessageScopeInfo }  from "@/components/ShareBoard/models/message_scope_info.js"

export class Xmessage {
  static create(params) {
    return new this(params)
  }

  constructor(params) {
    this.message            = params.message
    this.message_scope_key  = params.message_scope_key ?? "is_message_scope_public"
    this.from_connection_id = params.from_connection_id                    // null なら bot 等
    this.from_user_name     = params.from_user_name                        // null なら名前を表示しなくなる
    this.performed_at       = params.performed_at ?? TimeUtil.current_ms() // unique_key 生成用だけに利用

    this.unique_key = this.unique_key_generate()

    Object.freeze(this)
  }

  // 発言したときに toast にぶっこむ
  get toast_params() {
    return {
      container: ".MainBoard",
      position: "is-top",
      message: this.toast_message,
      type: this.toast_type,
      queue: false,
    }
  }

  // 表示するときのメッセージは加工しておく
  get auto_linked_message() {
    return Gs2.auto_link(this.message)
  }

  // 表示するときの色
  get css_class() {
    return {
      "has-text-success": this.message_scope_info.key === "is_message_scope_private",
    }
  }

  // スコープ
  get message_scope_info() {
    return MessageScopeInfo.fetch(this.message_scope_key)
  }

  // private

  get toast_message() {
    return `${Gs2.presence(this.from_user_name) ?? '？'}: ${this.message}`
  }

  get toast_type() {
    if (this.message_scope_info.key === "is_message_scope_private") {
      return "is-success"
    } else {
      return "is-white"
    }
  }

  unique_key_generate() {
    const str = [
      this.from_user_name,
      this.message,
      this.from_connection_id,
      this.performed_at,
    ].join("/")
    return Gs2.str_to_md5(str)
  }
}
