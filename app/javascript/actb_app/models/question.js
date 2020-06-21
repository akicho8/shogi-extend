import dayjs from "dayjs"

export class Question {
  constructor(question) {
    Object.assign(this, question)

    this.time_limit_sec_to_clock()
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

  get display_author() {
    return this.other_author || this.user.name
  }

  // private

  // 解答のSFENの配列を返す
  get answer_sfen_list() {
    return this.moves_answers.map(e => [this.init_sfen, "moves", e.moves_str].join(" "))
  }

  get base_clock() {
    return dayjs("2000-01-01T00:00:00+09:00")
  }
}
