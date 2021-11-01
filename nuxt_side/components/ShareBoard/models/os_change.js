import { Gs } from '@/components/models/gs.js'
import _ from "lodash"

export class OsChange {
  constructor() {
    this.list = []
  }

  append(str) {
    this.list.push(str)
  }

  clear() {
    this.list = []
  }

  get something() {
    return _.uniq(this.list).join("や")
  }

  get message() {
    return `${this.something}の変更を適用しないまま閉じようとしています。適用するにはキャンセルして「更新」をタップしてください`
  }

  get has_value_p() {
    return Gs.present_p(this.list)
  }
}
