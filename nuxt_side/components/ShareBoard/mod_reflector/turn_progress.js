export class TurnProgress {
  static create(...args) {
    return new this(...args)
  }

  constructor(params = {}) {
    params = {
      current: 0,
      ...params,
    }
    if (params.to == null && params.by == null) {
      params.by = 0
    }
    Object.assign(this, params)
    Object.freeze(this)
  }

  get new_value() {
    let value = null
    if (this.to != null) {
      value = this.to
    }
    if (this.by != null) {
      value = this.current + this.by
    }
    if (value < 0) {
      value = 0
    }
    return value
  }

  get diff() {
    return this.new_value - this.current
  }

  get step() {
    return Math.abs(this.diff)
  }

  get next_p() {
    return this.diff > 0
  }

  get previous_p() {
    return this.diff < 0
  }

  get same_p() {
    return this.diff === 0
  }

  get initial_position_p() {
    return this.new_value === 0
  }

  get will_message() {
    let str = null

    if (this.initial_position_p) {
      str = `初期配置に戻る`
    }

    if (str == null) {
      if (this.to != null) {
        if (this.next_p) {
          str = `${this.new_value}手目に進む`
        } else if (this.previous_p) {
          str = `${this.new_value}手目に戻る`
        } else {
          str = `${this.new_value}手目に戻る`
        }
      }
    }

    if (str == null) {
      if (this.by != null) {
        if (this.next_p) {
          str = `${this.step}手進む`
        } else if (this.previous_p) {
          str = `${this.step}手戻る`
        } else {
          str = `${this.step}手戻る`
        }
      }
    }

    return str
  }

  get past_message() {
    let str = this.will_message
    str = str.replace(/進む/, "進めました")
    str = str.replace(/戻る/, "戻りました")
    str = str.replace(/する/, "しました")
    return str
  }

  get label() {
    return `局面変更 #${this.new_value}`
  }
}
