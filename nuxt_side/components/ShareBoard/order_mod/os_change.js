import { Gs2 } from '@/components/models/gs2.js'
import _ from "lodash"

export class OsChange {
  constructor() {
    this.list = []
  }

  append(str) {
    this.list = _.uniq([...this.list, str])
  }

  clear() {
    this.list = []
  }

  get something() {
    return this.list.join("や")
  }

  get message() {
    return `${this.something}の変更を適用しないまま閉じようとしています<br>適用するにはキャンセルして確定をタップしてください`
  }

  get has_value_p() {
    return Gs2.present_p(this.list)
  }
}
