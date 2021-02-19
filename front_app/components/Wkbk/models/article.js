import dayjs from "dayjs"
import { ModelBase } from "../../models/model_base.js"

export class Article extends ModelBase {
  constructor(article) {
    super()
    Object.assign(this, article)
  }

  // 保存後にどこのスコープにするか？
  get redirect_scope_after_save() {
    return this.folder_key
    // if (this.book) {
    //   return this.book.folder_key
    // } else {
    //   return "private"
    // }
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

  ////////////////////////////////////////////////////////////////////////////////

  init_sfen_with(moves_answer) {
    return [this.init_sfen, "moves", moves_answer.moves_str].join(" ")
  }

  // sfenは正解か？
  sfen_valid_p(sfen) {
    return this.answer_sfen_list.includes(sfen)
  }

  // movesは正解か？
  moves_valid_p(moves) {
    return this.moves_answers.some(e => e.moves_str === moves.join(" "))
  }

  // すべての解答の中から最大手数を得る
  get moves_count_max() {
    return Math.max(...this.moves_answers.map(e => e.moves_count))
  }

  // public

  // 解答のSFENの配列を返す
  get answer_sfen_list() {
    return this.moves_answers.map(e => this.init_sfen_with(e))
  }

  // 非公開になっているか？
  // folder_key の判定はサーバ側で行っている
  // クライアント側では有効なデータかどうかだけを見る
  get invisible_p() {
    return this.init_sfen == null
  }
}
