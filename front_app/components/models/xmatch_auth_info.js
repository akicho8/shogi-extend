import MemoryRecord from 'js-memory-record'

export class XmatchAuthInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "login_required",        name: "ログイン必須", message: null, },
      { key: "handle_name_required",  name: "ログイン不要", message: null, },
    ]
  }
}
