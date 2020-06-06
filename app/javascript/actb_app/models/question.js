export class Question {
  constructor(question) {
    Object.assign(this, question)
  }

  // sfenは正解か？
  answer_p(sfen) {
    return this.answer_sfen_list.includes(sfen)
  }

  // 盤面の初期状態
  get full_init_sfen() {
    return this.init_sfen
  }

  // すべての解答の中から最大手数を得る
  get moves_count_max() {
    return Math.max(...this.moves_answers.map(e => e.moves_count))
  }

  get display_author() {
    return this.source_desc || this.user.name
  }

  // private

  // 解答のSFENの配列を返す
  get answer_sfen_list() {
    return this.moves_answers.map(e => [this.init_sfen, "moves", e.moves_str].join(" "))
  }
}
