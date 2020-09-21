import Location from "shogi-player/src/location.js"
import dayjs from "dayjs"

const ONE_MIN = 60

export class SingleClock {
  static time_format(v) {
    let format = null
    if ((v / ONE_MIN) >= ONE_MIN) {
      format = "h:mm:ss"
    } else {
      format = "m:ss"
    }
    return dayjs().startOf("year").set("seconds", v).format(format)
  }

  constructor(base, index) {
    this.base  = base
    this.index = index

    // FIXME: params は取る
    this.initial_main_sec  = base.params.initial_main_sec || ONE_MIN * 3
    this.initial_extra_sec = base.params.initial_extra_sec || 0
    this.initial_read_sec  = base.params.initial_read_sec || 0
    this.every_plus        = base.params.every_plus || 0

    this.variable_reset()
  }

  variable_reset() {
    this.main_sec  = this.initial_main_sec
    this.extra_sec = this.initial_extra_sec
    this.read_sec  = this.initial_read_sec
  }

  copy_from(o) {
    this.main_sec  = o.main_sec
    this.read_sec  = o.read_sec
    this.extra_sec = o.extra_sec

    this.initial_read_sec  = o.initial_read_sec
    this.initial_main_sec  = o.initial_main_sec
    this.initial_extra_sec = o.initial_extra_sec
    this.every_plus        = o.every_plus
  }

  rule_set_one(o) {
    this.initial_read_sec  = o.initial_read_sec
    this.initial_main_sec  = o.initial_main_sec
    this.initial_extra_sec = o.initial_extra_sec
    this.every_plus        = o.every_plus

    this.variable_reset()
  }

  generation_next(value) {
    if (value != null) {

      this.main_sec += value
      if (this.main_sec < 0) {
        this.read_sec += this.main_sec
        this.main_sec = 0
        if (this.read_sec < 0) {
          this.extra_sec += this.read_sec
          this.read_sec = 0
          if (this.extra_sec < 0) {
            this.extra_sec = 0
          }
        }
      }

      if (value < 0) {
        const t = this.main_sec
        if (t >= 1) {
          this.second_decriment_hook_call("main_sec", t)
        } else {
          const t = this.read_sec
          if (t >= 1) {
            this.second_decriment_hook_call("read_sec", t)
          } else {
            const t = this.extra_sec
            if (t >= 1) {
              this.second_decriment_hook_call("extra_sec", t)
            }
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

  second_decriment_hook_call(key, t) {
    const m = Math.trunc(t / ONE_MIN)
    const s = t % ONE_MIN
    this.base.params.second_decriment_hook(this, key, t, m, s)
  }

  switch_handle() {
    if (this.running_p) {
      this.tap_and_auto_start_handle()
    } else {
      this.set_or_tap_handle()
    }
  }

  simple_switch_handle() {
    if (this.active_p) {
      this.generation_next(this.every_plus)
      this.read_sec_set()
      this.base.clock_switch()
    }
  }

  tap_and_auto_start_handle() {
    if (!this.running_p) {
      this.base.initial_boot_from(this.index)
      this.base.clock_switch()
      return
    }
    this.simple_switch_handle()
  }

  set_or_tap_handle() {
    if (!this.running_p) {
      if (this.turn == null) {
        this.base.turn = this.index
      }
    }
    this.base.clock_switch()
  }

  read_sec_set() {
    // if (this.read_sec < this.initial_read_sec) {
    this.read_sec = this.initial_read_sec
    // }
  }

  //////////////////////////////////////////////////////////////////////////////// getter

  get button_type() {
    if (!this.running_p) {
      return
    }
    if (this.active_p) {
      return "is-primary"
    }
  }

  get active_p() {
    return this.index === this.base.current_index
  }

  get dom_class() {
    const ary = []
    if (this.running_p) {
      if (this.active_p) {
        ary.push("is_sclock_active")
        if (this.main_sec === 0) {
          ary.push(this.base.params.active_value_zero_class)
          ary.push("sclock_zero")
        } else {
          ary.push(this.base.params.active_value_nonzero_class)
          ary.push("sclock_nonzero")
        }
      } else {
        ary.push(this.base.params.inactive_class)
        ary.push("is_sclock_inactive")
      }
    }
    return ary
  }

  get bar_class() {
    const ary = []
    if (this.running_p) {
      if (this.active_p) {
        if (this.rest >= 1) {
          ary.push("is_blink")
        }
        if (this.rest <= 5) {
          ary.push("is_level4")
        } else if (this.rest <= 10) {
          ary.push("is_level3")
        } else if (this.rest < 60) {
          ary.push("is_level2")
        } else {
          ary.push("is_level1")
        }
      } else {
      }
    }
    return ary
  }

  get to_time_format() {
    return this.constructor.time_format(this.main_sec)
  }

  get to_time_format2() {
    return this.constructor.time_format(this.read_sec)
  }

  get running_p() {
    return this.base.running_p
  }

  get location() {
    return Location.fetch(this.index)
  }

  get rest() {
    return this.main_sec + this.read_sec + this.extra_sec
  }

  //////////////////////////////////////////////////////////////////////////////// for style

  get display_lines() {
    return [
      this.initial_main_sec,
      this.initial_read_sec,
      this.initial_extra_sec,
    ].filter(e => (e >= 1)).length
  }

  //////////////////////////////////////////////////////////////////////////////// for v-model

  get main_minute_for_vmodel() {
    return Math.trunc(this.initial_main_sec / ONE_MIN)
  }

  set main_minute_for_vmodel(v) {
    this.initial_main_sec = Math.trunc(v * ONE_MIN)
    this.main_sec = this.initial_main_sec
    // this.read_sec_set()
  }

  get initial_read_sec_for_v_model() {
    return this.initial_read_sec
  }

  set initial_read_sec_for_v_model(v) {
    this.initial_read_sec = v
    this.read_sec_set()
  }

  get initial_extra_sec_for_v_model() {
    return this.initial_extra_sec
  }

  set initial_extra_sec_for_v_model(v) {
    this.initial_extra_sec = v
    this.extra_sec = v
  }
}
