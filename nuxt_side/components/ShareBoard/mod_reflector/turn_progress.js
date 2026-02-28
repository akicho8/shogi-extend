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
    if (false) {
    } else if (this.to != null) {
      if (this.initial_position_p) {
        str = `初期配置に戻る`
      } else {
        str = `${this.new_value}手目に移動する`
      }
    } else if (this.next_p) {
      str = `${this.step}手進める`
    } else if (this.previous_p) {
      str = `${this.step}手戻る`
    } else {
      str = `${this.new_value}手目に戻る`
    }
    return str
  }

  get message() {
    let str = null
    if (false) {
    } else if (this.to != null) {
      if (this.initial_position_p) {
        str = `初期配置に戻しました`
      } else {
        str = `${this.new_value}手目に移動しました`
      }
    } else if (this.next_p) {
      str = `${this.step}手進めました`
    } else if (this.previous_p) {
      str = `${this.step}手戻しました`
    } else {
      str = `${this.step}手進めました (手数変化なし)`
    }
    return str
  }
}
