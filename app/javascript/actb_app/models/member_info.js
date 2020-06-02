export class MemberInfo {
  constructor() {
    this.ox_list = []
    this.b_score = 0
    this.latest_ox = null
    this.delay_id = null
  }

  // get ox_list() {
  //   return this.ox_list
  // }

  droped_ox_list(n) {
    return _.takeRight(this.ox_list, n)
  }

  // get b_score() {
  //   return this.b_score
  // }

  // get latest_ox() {
  //   return this.latest_ox
  // }

  get o_count() {
    return this.ox_list.filter(e => e === 'correct').length
  }
}
