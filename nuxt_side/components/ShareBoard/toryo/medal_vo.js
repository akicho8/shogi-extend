export class MedalVo {
  constructor(counts_hash, user_name) {
    this.counts_hash = counts_hash
    this.user_name = user_name
  }

  get count() {
    return this.counts_hash[this.user_name] ?? 0
  }

  get exist_p() {
    return this.count > 0
  }

  get count_lteq_max() {
    return this.count <= this.__max
  }

  // 実際に表示するメダルたち
  get visible_medal_text() {
    return this.__medal_char.repeat(this.__visible_medal_count)
  }

  //////////////////////////////////////////////////////////////////////////////// private

  // 実際に表示できるメダル数
  get __visible_medal_count() {
    if (this.count_lteq_max) {
      return this.count
    } else {
      return 1
    }
  }

  get __medal_char() {
    return "⭐"
  }

  get __max() {
    return 5
  }
}
