import { Model } from "./model.js"
import { Lemon } from "./lemon.js"
import { FolderInfo } from "./folder_info.js"

export class Banana extends Model {
  constructor(context, attributes) {
    super(context, attributes)
    if (this.lemon) {
      this.lemon = new Lemon(this.context, this.lemon)
    }
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
      key:           this.key,
      title:         this.title,
      description:   this.description,
      folder_key:    this.folder_key,
      lemon_id:      this.lemon_id,
      tag_list:      this.tag_list,
      thumbnail_pos: this.thumbnail_pos,
    }
  }

  get folder_info() {
    return FolderInfo.fetch(this.folder_key)
  }
}
