import Location from "shogi-player/src/location.js"
import dayjs from "dayjs"

const ONE_MIN = 60

export class SingleClock {
  constructor(base, index) {
    this.base         = base
    this.index        = index

    this.main_second  = base.params.max || ONE_MIN * 3
    this.delay_second = base.params.delay_second || 0
    this.range_low    = base.params.range_low || 0
    this.every_plus   = base.params.every_plus || 0
  }

  copy_from(o) {
    this.main_second  = o.main_second
    this.delay_second = o.delay_second
    this.range_low    = o.range_low
    this.every_plus   = o.every_plus
  }

  generation_next(value) {
    if (value != null) {

      let v = this.main_second + value
      if (v < 0) {
        this.delay_second += v
        if (this.delay_second < 0) {
          this.delay_second = 0
        }
        v = 0
      }
      this.main_second = v

      if (value < 0) {
        const v = this.main_second
        if (v >= 1) {
          const d = Math.trunc(v / ONE_MIN)
          const r = v % ONE_MIN
          this.base.params.second_decriment_hook(v, d, r)
        } else {
          const v = this.delay_second
          if (v >= 1) {
            const d = Math.trunc(v / ONE_MIN)
            const r = v % ONE_MIN
            this.base.params.second_decriment_hook(v, d, r)
          }
        }
      }

      if (!this.base.zero_arrival) {
        if (this.rest === 0) {
          if (this.base.timer) {
            this.base.zero_arrival = true
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
        this.generation_next(this.every_plus)
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
    if (this.main_second < this.range_low) {
      this.main_second = this.range_low
    }
  }

  //////////////////////////////////////////////////////////////////////////////// getter

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
        if (this.main_second === 0) {
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
    if ((this.main_second / ONE_MIN) >= ONE_MIN) {
      format = "h:mm:ss"
    } else {
      format = "m:ss"
    }
    return dayjs().startOf("year").set("seconds", this.main_second).format(format)
  }

  get standby_mode_p() {
    return this.base.standby_mode_p
  }

  get location() {
    return Location.fetch(this.index)
  }

  get rest() {
    return this.main_second + this.delay_second
  }

  //////////////////////////////////////////////////////////////////////////////// for v-model

  get main_minute_for_vmodel() {
    return Math.trunc(this.main_second / ONE_MIN)
  }

  set main_minute_for_vmodel(v) {
    this.main_second = Math.trunc(v * ONE_MIN)
    this.clamp_value()
  }

  get range_low_for_v_model() {
    return this.range_low
  }

  set range_low_for_v_model(v) {
    this.range_low = v
    this.clamp_value()
  }
}
