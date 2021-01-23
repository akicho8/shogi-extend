import { Article } from "./article.js"
import { ModelBase } from "../../models/model_base.js"

export class Book extends ModelBase {
  constructor(attributes) {
    super()
    Object.assign(this, attributes)
    if (this.articles) {
      this.articles = this.articles.map(e => new Article(e))
    }
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
