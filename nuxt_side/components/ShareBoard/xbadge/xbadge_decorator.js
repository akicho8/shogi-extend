export class XbadgeDecorator {
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

  // 実際に表示するバッジたち
  get visible_badge_text() {
    return this.__badge_char.repeat(this.__visible_badge_count)
  }

  //////////////////////////////////////////////////////////////////////////////// private

  // 実際に表示できるバッジ数
  get __visible_badge_count() {
    if (this.count_lteq_max) {
      return this.count
    } else {
      return 1
    }
  }

  get __badge_char() {
    return "⭐"
  }

  get __max() {
    return 5
  }
}
