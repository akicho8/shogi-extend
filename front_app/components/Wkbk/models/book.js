import { Article } from "./article.js"
import { FolderInfo } from "./folder_info.js"
import { ModelBase } from "../../models/model_base.js"

export class Book extends ModelBase {
  constructor(attributes) {
    super()
    Object.assign(this, attributes)
    if (this.articles) {
      this.articles = this.articles.map(e => new Article(e))
    }

    this.new_file_info = null   // b-upload で受けとる情報
    this.new_file_src  = null   // 読み込んだ内容

    // vue の data に設定すると Book が Object になっている謎
    // なのでここで入れているが何かがおもいっきり間違っている気がする
    // あとでぜったいバグるところ
    if (this.folder) {
      throw new Error("すでに this.folder がある")
    }
    this.folder = FolderInfo.fetch(this.folder_key).attributes
  }

  //////////////////////////////////////////////////////////////////////////////// 権限

  owner_p(user) {
    // 新規レコードは誰でもオーナー
    if (this.new_record_p) {
      return true
    }

    if (user) {
      return user.id === this.user.id
    }
  }
}
