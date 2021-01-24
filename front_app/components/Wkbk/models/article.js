import dayjs from "dayjs"
import { ModelBase } from "../../models/model_base.js"

export class Article extends ModelBase {
  constructor(article) {
    super()
    Object.assign(this, article)

    this.time_limit_sec_to_clock()
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

  //////////////////////////////////////////////////////////////////////////////// b-timepicker 用

  // 秒 → Date 変換
  time_limit_sec_to_clock() {
    this.time_limit_clock = this.base_clock.add(this.time_limit_sec, "second").toDate()
  }

  // Date → 秒 変換 (元に戻す)
  time_limit_clock_to_sec() {
    this.time_limit_sec = dayjs(this.time_limit_clock).diff(this.base_clock) / 1000
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

  // 作家名(他者が作者の場合は優先して返す)
  get display_author() {
    return this.source_author || this.user.name
  }

  // 「他者が作者」の情報が一つでも含まれている？
  get source_author_collapse_open_p() {
    return !!(this.source_about_key === 'unknown' ||
              this.source_author                  ||
              this.source_media_name              ||
              this.source_media_url               ||
              false
             )
  }

  //////////////////////////////////////////////////////////////////////////////// for b-datepicker
  get date_casted_source_published_on() {
    console.log("get", "source_published_on", this.source_published_on)
    if (this.source_published_on) {
      return new Date(Date.parse(this.source_published_on))
    }
  }
  set date_casted_source_published_on(v) {
    this.source_published_on = v.toLocaleDateString() // Dataオブジェクト -> "2020/1/2"
    console.log("set", "source_published_on", this.source_published_on)
  }
  ////////////////////////////////////////////////////////////////////////////////

  // public

  // 解答のSFENの配列を返す
  get answer_sfen_list() {
    return this.moves_answers.map(e => this.init_sfen_with(e))
  }

  get base_clock() {
    return dayjs("2000-01-01T00:00:00+09:00")
  }
}
