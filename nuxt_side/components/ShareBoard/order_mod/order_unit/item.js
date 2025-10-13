// 動かすもの
// 将来的に user_name 以外のものを入れるかもしれないのでラップしておく

import _ from "lodash"
import { GX } from "@/components/models/gs.js"

export class Item {
  static create(user_name) {
    return new this({user_name: user_name})
  }

  constructor(object) {
    Object.assign(this, object)
    this.unique_key = _.uniqueId("item")
  }

  get to_s() {
    return this.user_name
  }

  // この結果を create に食わすと元に戻るようにする
  get as_json() {
    return this.user_name
  }

  // ダンプしたときわかりやすくしたときにコメントをはずす
  // toJSON() {
  //   return this.user_name
  // }
}
