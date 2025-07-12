import _ from "lodash"
import { Location } from "shogi-player/components/models/location.js"
import dayjs from "dayjs"
import { Gs } from "@/components/models/gs.js"

const SEC_PER_MIN = 60
const MIN_PER_HOUR = 60

export class SingleClock {
  static time_format(v) {
    let format = null
    if (v < SEC_PER_MIN) {
      format = "s"
    } else if (v < SEC_PER_MIN * MIN_PER_HOUR) {
      format = "m:ss"
    } else {
      format = "h:mm:ss"
    }
    return dayjs().startOf("year").set("seconds", v).format(format)
  }

  constructor(base, index) {
    this.base  = base
    this.index = index

    this.initial_main_sec  = base.params.initial_main_sec ?? SEC_PER_MIN * 3
    this.initial_extra_sec = base.params.initial_extra_sec ?? 0
    this.initial_read_sec  = base.params.initial_read_sec ?? 0
    this.every_plus        = base.params.every_plus ?? 0

    this.variable_reset()
  }

  variable_reset() {
    this.main_sec  = this.initial_main_sec
    this.extra_sec = this.initial_extra_sec
    this.read_sec  = this.initial_read_sec

    this.minus_sec            = 0
    this.elapsed_sec          = 0
    this.elapsed_sec_old      = 0
    this.read_koreyori_count  = 0
    this.extra_koreyori_count = 0
  }

  copy_from(o) {
    this.main_sec  = o.main_sec
    this.read_sec  = o.read_sec
    this.extra_sec = o.extra_sec

    this.minus_sec            = o.minus_sec
    this.elapsed_sec          = o.elapsed_sec
    this.elapsed_sec_old      = o.elapsed_sec_old
    this.read_koreyori_count  = o.read_koreyori_count
    this.extra_koreyori_count = o.extra_koreyori_count

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
      this.elapsed_sec += value

      const previous_changes = {
        main_sec: this.main_sec,
        read_sec: this.read_sec,
        extra_sec: this.extra_sec,
      }

      // 減算
      this.main_sec += value
      if (this.main_sec < 0) {
        this.read_sec += this.main_sec
        this.main_sec = 0
        if (this.read_sec < 0) {
          this.extra_sec += this.read_sec
          this.read_sec = 0
          if (this.extra_sec < 0) {
            this.minus_sec += this.extra_sec
            this.extra_sec = 0
          }
        }
      }

      // ここは減算したあとの状態で「30秒」などと発声するためのコールバック
      if (value < 0) {
        const t = this.main_sec
        if (t >= 1) {
          this.second_decriment_fn_call("main_sec", t)
        } else {
          const t = this.read_sec
          if (t >= 1) {
            this.second_decriment_fn_call("read_sec", t)
          } else {
            const t = this.extra_sec
            if (t >= 1) {
              this.second_decriment_fn_call("extra_sec", t)
            }
          }
        }
      }

      // 「これより1手N秒でお願いします」
      if (this.read_koreyori_count === 0) {                          // 初回なら
        if (previous_changes.main_sec >= 1 && this.main_sec === 0) { // 残り時間 1 -> 0 のタイミングで
          if (this.read_sec >= 1) {                                  // 秒読みが残っていれば
            this.base.params.read_koreyori_fn(this)                  // 「これより1手N秒でお願いします」
            this.read_koreyori_count += 1                            // 実行回数を記録しておく
          }
        }
      }

      // 「深考時間が0になったら負けです」
      if (this.extra_koreyori_count === 0) {                           // 初回なら
        if ((previous_changes.main_sec >= 1 && this.main_sec === 0) || // 残り時間 1 -> 0 または
            (previous_changes.read_sec >= 1 && this.read_sec === 0)) { // 秒読み   1 -> 0 のタイミングで
          if (this.extra_sec >= 1) {                                   // 深考時間が残っていれば
            this.base.params.extra_koreyori_fn(this)                   // 「深考時間が0になったら負けです」
            this.extra_koreyori_count += 1                             // 実行回数を記録しておく
          }
        }
      }

      // チーン
      if (this.rest === 0) {
        if (this.base.timer) {
          this.base.params.time_zero_fn(this)
        }
      }
    }
  }

  second_decriment_fn_call(key, sec) {
    const [mm, ss] = Gs.idivmod(sec, SEC_PER_MIN)
    this.base.params.second_decriment_fn(this, key, sec, mm, ss)
  }

  // 指した直後に時計のボタンを押す
  tap_on() {
    if (this.active_p) {
      this.rebirth()
      this.base.clock_switch()
    }
  }

  // 1手指したときに再生する値
  rebirth() {
    if (this.pause_or_play_p) {
      this.main_sec += this.every_plus
      // this.generation_next(this.every_plus)
      this.read_sec_set()
      this.minus_sec = 0 // 押したらマイナスになったぶんは0に戻しておく。これで再びチーンになる
      this.elapsed_sec_old = this.elapsed_sec // 前回の値を保持する
      this.elapsed_sec = 0
    }
  }

  read_sec_set() {
    this.read_sec = this.initial_read_sec
  }

  //////////////////////////////////////////////////////////////////////////////// getter

  // 時間回復系のパラメータになっている？
  // つまり「秒読み」と「フィッシャー」のときのみ true
  get time_recovery_mode_p() {
    return this.initial_read_sec >= 1 || this.every_plus >= 1
  }

  // 回復するパラメータの名前
  get time_recovery_params_human() {
    let a = []
    if (this.initial_read_sec >= 1) {
      a.push("秒読み")
    }
    if (this.every_plus >= 1) {
      a.push("1手毎加算秒")
    }
    return a.join("と")
  }

  get button_type() {
    if (!this.pause_or_play_p) {
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
    let ary = []
    if (this.pause_or_play_p) {
      if (this.active_p) {
        ary.push("is_sclock_active")
        if (this.main_sec === 0) {
          ary.push(this.base.params.active_value_zero_css_class)
          ary.push("is_sclock_zero")
        } else {
          ary.push(this.base.params.active_value_nonzero_css_class)
          ary.push("is_sclock_nonzero")
        }
      } else {
        ary.push(this.base.params.inactive_css_class)
        ary.push("is_sclock_inactive")
      }
    }
    return _.compact(ary)
  }

  // 残り時間に対応したCSSクラスを返す
  get rest_class() {
    const ary = []
    if (this.pause_or_play_p) {
      if (this.active_p) {
        if (this.rest >= 1) {
          ary.push("cc_rest_gteq_1")
        }
        if (this.rest <= 5) {
          ary.push("cc_rest_lteq_5")
        } else if (this.rest <= 10) {
          ary.push("cc_rest_lteq_10")
        } else if (this.rest < 60) {
          ary.push("cc_rest_lt_60")
        } else {
          ary.push("cc_rest_gteq_60")
        }
      } else {
      }
    }
    return ary
  }

  get main_sec_mmss() {
    return this.constructor.time_format(this.main_sec)
  }

  get read_sec_mmss() {
    return this.constructor.time_format(this.read_sec)
  }

  get extra_sec_mmss() {
    return this.constructor.time_format(this.extra_sec)
  }

  get pause_or_play_p() {
    return this.base.pause_or_play_p
  }

  get location() {
    return Location.fetch(this.index)
  }

  get rest() {
    return this.main_sec + this.read_sec + this.extra_sec + this.minus_sec
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
    return Math.trunc(this.initial_main_sec / SEC_PER_MIN)
  }

  set main_minute_for_vmodel(v) {
    this.initial_main_sec = Math.trunc(v * SEC_PER_MIN)
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

  //////////////////////////////////////////////////////////////////////////////// for serialize

  // foo.attributes = bar.attributes
  get attributes() {
    return {
      main_sec:          this.main_sec,
      read_sec:          this.read_sec,
      extra_sec:         this.extra_sec,
      minus_sec:         this.minus_sec,
      elapsed_sec:       this.elapsed_sec,
      elapsed_sec_old:   this.elapsed_sec_old,
      read_koreyori_count:    this.read_koreyori_count,
      extra_koreyori_count:    this.extra_koreyori_count,
      initial_read_sec:  this.initial_read_sec,
      initial_main_sec:  this.initial_main_sec,
      initial_extra_sec: this.initial_extra_sec,
      every_plus:        this.every_plus,
    }
  }
  set attributes(v) {
    this.copy_from(v)
  }
}
