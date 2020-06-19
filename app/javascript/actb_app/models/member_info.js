export class MemberInfo {
  constructor(membership_id) {
    this.membership_id = membership_id

    this.ox_list = [] // 正解・不正解をpushしていく
    this.b_score = 0  // 一定以上になると勝ちになるスコア

    // ○×を一瞬表示する用
    this.latest_ox = null
    this.delay_id  = null

    this.member_active_p = true        // true:部屋にいる false:切断した
  }

  // 解答リストの最後のN個
  droped_ox_list(n) {
    return _.takeRight(this.ox_list, n)
  }

  // 正解数
  get o_count() {
    return this.ox_list.filter(e => e === 'correct').length
  }
}
