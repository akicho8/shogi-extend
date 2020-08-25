import Location from "shogi-player/src/location.js"
import dayjs from "dayjs"

export class SingleClock {
  constructor(base, index) {
    this.base            = base
    this.index           = index
    // this.max             = base.params.max || 60 * 3
    this.value           = base.params.max || 60 * 3
    this.range_low       = base.params.range_low || 0
    this.every_add_value = base.params.every_add_value || 0
    this.yuuyo           = base.params.yuuyo || 0
  }

  copy_from(o) {
    this.value           = o.value
    this.range_low       = o.range_low
    this.every_add_value = o.every_add_value
    this.yuuyo           = o.yuuyo
  }

  generation_next(value) {
    if (value != null) {
      this.value += value
      if (this.value < 0) {
        this.yuuyo += this.value
        if (this.yuuyo < 0) {
          this.yuuyo = 0
        }
        this.value = 0
      }

      if (value < 0) {
        const v = this.value
        if (v >= 1) {
          const d = Math.trunc(v / 60)
          const r = v % 60
          this.base.params.yomiage_hook(v, d, r)
        } else {
          const v = this.yuuyo
          if (v >= 1) {
            const d = Math.trunc(v / 60)
            const r = v % 60
            this.base.params.yomiage_hook(v, d, r)
          }
        }
      }

      if (!this.base.clock_done) {
        if (this.rest === 0) {
          if (this.base.timer) {
            this.base.clock_done = true
            this.base.params.time_zero_callback(this)
          }
        }
      }
    }
  }

  switch_handle() {
    if (this.standby_mode_p) {
      this.set_or_tap_handle()
    } else {
      this.tap_and_auto_start_handle()
    }
  }

  tap_and_auto_start_handle() {
    if (this.standby_mode_p) {
      this.base.initial_boot_from(this.index)
    }
    if (this.active_p) {
      if (this.base.counter >= 1) {
        this.generation_next(this.every_add_value)
        this.clamp_value()
      }
      this.base.clock_switch()
    }
  }

  set_or_tap_handle() {
    if (this.standby_mode_p) {
      if (this.turn == null) {
        this.base.turn = this.index
      }
    }
    this.base.clock_switch()
  }

  clamp_value() {
    if (this.value < this.range_low) {
      this.value = this.range_low
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
    const ary = []
    if (this.standby_mode_p) {
    } else {
      if (this.active_p) {
        ary.push("sclock_active")
        if (this.value === 0) {
          ary.push(this.base.params.active_value_zero_class)
          ary.push("sclock_zero")
        } else {
          ary.push(this.base.params.active_value_nonzero_class)
          ary.push("sclock_nonzero")
        }
      } else {
        ary.push(this.base.params.inactive_class)
        ary.push("sclock_inactive")
      }
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
    return this.base.standby_mode_p
  }

  get location() {
    return Location.fetch(this.index)
  }

  get value_for_v_model() {
    return Math.trunc(this.value / 60)
  }
  set value_for_v_model(v) {
    this.value = Math.trunc(v * 60)
    this.clamp_value()
  }

  get range_low_for_v_model() {
    return this.range_low
  }
  set range_low_for_v_model(v) {
    this.range_low = v
    this.clamp_value()
  }

  get rest() {
    return this.value + this.yuuyo
  }
}
