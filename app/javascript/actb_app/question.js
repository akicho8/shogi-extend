export class Question {
  constructor(question) {
    Object.assign(this, question)
  }

  // 盤面の初期状態
  get full_init_sfen() {
    return ["position", "sfen", this.init_sfen].join(" ")
  }

  // sfenは正解か？
  answer_p(sfen) {
    return this.answer_sfen_list.includes(sfen)
  }

  // private

  // 解答のSFENの配列を返す
  get answer_sfen_list() {
    return this.moves_answers.map(e => ["position", "sfen", this.init_sfen, "moves", e.moves_str].join(" "))
  }
}
