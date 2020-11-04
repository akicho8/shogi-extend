import Vue from "vue"

export class MemberInfo {
  constructor(membership_id) {
    this.membership_id = membership_id

    this.ox_list = [] // 正解・不正解をpushしていく
    this.b_score = 0  // 一定以上になると勝ちになるスコア

    this.member_active_p = true        // true:部屋にいる false:切断した

    // 間違えた問題ハッシュ
    this.otetuki_hash = {}
  }

  // 解答リストの最後のN個
  droped_ox_list(n) {
    return _.takeRight(this.ox_list, n)
  }

  // 正解数
  get o_count() {
    return this.ox_list.filter(e => e === 'correct').length
  }

  // スコアの加算
  score_add(diff) {
    let v = this.b_score + diff
    if (v < 0) {
      v = 0
    }
    this.b_score = v
  }
}
