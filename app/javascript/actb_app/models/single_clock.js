import dayjs from "dayjs"

export class SingleClock {
  constructor(base, index) {
    this.base = base
    this.index = index
    this.max   = base.params.max || 60 * 3
    this.value = this.max
  }

  generation_next(value) {
    if (value != null) {
      this.value += value
      if (this.value < 0) {
        this.value = 0
      }
    }
  }

  turn_end_handle() {
    if (this.standby_mode_p) {
      this.base.initial_boot_from(this.index)
    }
    if (this.active_p) {
      if (this.base.counter >= 1) {
        this.generation_next(this.base.params.every_add_value)
      }
      this.base.clock_switch()
    }
  }

  get button_type() {
    if (this.standby_mode_p) {
      return
    }
    if (this.active_p) {
      return "is-primary"
    }
  }

  get disabled_p() {
    if (this.standby_mode_p) {
      return false
    }
    return !this.active_p
  }

  get active_p() {
    return this.index === this.base.current_index
  }

  get dom_class() {
    if (this.standby_mode_p) {
      return []
    }
    const ary = []
    if (this.active_p) {
      if (this.value === 0) {
        ary.push("has-text-danger")
      } else {
        ary.push("has-text-primary")
      }
    } else {
      ary.push("has-text-grey-light")
    }
    return ary
  }

  get to_time_format() {
    let format = null
    if ((this.value / 60) >= 60) {
      format = "HH:mm:ss"
    } else {
      format = "m:ss"
    }
    return dayjs().startOf("year").set("seconds", this.value).format(format)
  }

  get standby_mode_p() {
    return this.base.turn == null
  }
}
