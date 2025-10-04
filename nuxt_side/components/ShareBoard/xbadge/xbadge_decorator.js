export class XbadgeDecorator {
  constructor(user_name, match_record) {
    this.user_name = user_name
    this.match_record = match_record ?? { win_count: 0, lose_count: 0 }
  }

  get win_count() {
    return this.match_record.win_count
  }

  get lose_count() {
    return this.match_record.lose_count
  }

  get total_count() {
    return this.win_count + this.lose_count
  }

  get win_rate() {
    if (this.total_count ==  0) {
      return
    }
    return this.win_count / this.total_count
  }

  get win_rate_human() {
    if (this.win_rate == null) {
      return ""
    }
    return this.win_rate.toFixed(3)
  }

  get win_rate_inspect() {
    return `${this.win_rate_human} (${this.win_count}勝 ${this.lose_count}敗)`
  }

  get exist_p() {
    return this.win_count > 0
  }

  get win_count_lteq_max() {
    return this.win_count <= this.__max
  }

  // 実際に表示するバッジたち
  get visible_badge_text() {
    return this.__badge_char.repeat(this.__visible_badge_count)
  }

  //////////////////////////////////////////////////////////////////////////////// private

  // 実際に表示できるバッジ数
  get __visible_badge_count() {
    if (this.win_count_lteq_max) {
      return this.win_count
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
