// |---------------------|
// | content             |
// | auto_linked_message |
// | from_connection_id  |
// | from_user_name      |
// | unique_key          |
// | toast_params        |
// | message_class       |
// |---------------------|

import { GX } from "@/components/models/gs.js"
import { TimeUtil } from "@/components/models/time_util.js"
import { MessageScopeInfo } from "@/components/ShareBoard/models/message_scope_info.js"
import { MessageValidator } from "@/components/models/arashi_killer/message_validator.js"

export class MessageRecord {
  static create(params) {
    return new this(params)
  }

  constructor(params) {
    this.id                 = params.id
    this.content            = params.content
    this.message_scope_key  = params.message_scope_key ?? "ms_public"
    this.from_connection_id = params.from_connection_id                    // null なら bot 等
    this.from_user_name     = params.from_user_name                        // null なら名前を表示しなくなる
    this.from_avatar_path   = params.from_avatar_path                      // あればアバターが出て null は守護獣
    this.primary_emoji      = params.primary_emoji                         // 優先する絵文字
    this.performed_at       = params.performed_at ?? TimeUtil.current_ms() // unique_key 生成用だけに利用

    this.unique_key = this.unique_key_generate()

    Object.freeze(this)
  }

  // 発言したときに toast にぶっこむ
  get toast_params() {
    return {
      container: ".ShogiPlayer .MainBoard",
      position: "is-top",
      message: this.toast_message,
      type: this.toast_type,
      queue: false,
    }
  }

  // 表示するときのメッセージは加工しておく
  get auto_linked_message() {
    return GX.auto_link(this.content, {mention: false}) // `@alice` をリンクにしないようにする
  }

  // 表示できないときのメッセージ
  get invisible_message() {
    return "*".repeat(this.content.length)
  }

  // 表示するときの色
  get message_class() {
    return this.message_scope_info.message_class
  }

  // スコープ
  get message_scope_info() {
    return MessageScopeInfo.fetch(this.message_scope_key)
  }

  // private

  get toast_message() {
    const name = GX.presence(this.from_user_name) ?? "？"
    return `${name}: ${this.content}`
  }

  get toast_type() {
    return this.message_scope_info.toast_type
  }

  get message() {
    GX.assert(false)
  }

  unique_key_generate() {
    if (this.id) {
      // DBに入っているユニークなID
      return `${this.id}`
    } else {
      // DBに入っていない場合のID
      const str = [
        this.from_user_name,
        this.content,
        this.from_connection_id,
        this.performed_at,
      ].join("/")
      return GX.str_to_md5(str)
    }
  }

  // 荒らし判定したか？
  get content_invalid_p() {
    return MessageValidator.invalid_p(this.content)
  }

  // 荒らしではない
  get content_valid_p() {
    return MessageValidator.valid_p(this.content)
  }
}
