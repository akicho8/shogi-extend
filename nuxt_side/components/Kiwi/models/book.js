import { Model } from "./model.js"
import { Lemon } from "./lemon.js"

export class Book extends Model {
  constructor(context, attributes) {
    super(context, attributes)

    if (this.lemon) {
      this.lemon = new Lemon(this.context, this.lemon)
    }

    // this.new_file_info = null   // b-upload で受けとる情報
    // this.new_file_src  = null   // 読み込んだ内容

    // vue の data に設定すると Book が Object になっている謎
    // なのでここで入れているが何かがおもいっきり間違っている気がする
    // あとでぜったいバグるところ
    // if (this.folder) {
    //   throw new Error("すでに this.folder がある")
    // }
    // this.folder = FolderInfo.fetch(this.folder_key).attributes
  }

  //////////////////////////////////////////////////////////////////////////////// 権限

  // owner_p(user) {
  //   // 新規レコードは誰でもオーナー
  //   if (this.new_record_p) {
  //     return true
  //   }
  //
  //   if (user) {
  //     return user.id === this.user.id
  //   }
  // }

  get primary_key() {
    return "key"
  }

  // save するときにサーバー側に送るパララメータを絞る
  // まるごと送っても問題ないけど不要なものまで送ることになる
  // のちのち構造が変わってもここで吸収する
  get post_params() {
    return {
      title:       this.title,
      description: this.description,
      folder_key:  this.folder_key,
      lemon_id:    this.lemon_id,
      tag_list:    this.tag_list,
    }
  }
}
