import { SingleClock } from "./single_clock.js"
import Location from "shogi-player/src/location.js"

export class ChessClock {
  constructor(params = {}) {
    this.params = {
      // ここらのハッシュキーはリアクティブにするため null でも定義が必要
      turn: null,
      initial_read_sec: null,
      every_plus: null,
      initial_main_sec: null,
      read_sec: null,
      extra_sec: null,
      pause_p: null,

      time_zero_callback: e => {},
      clock_switch_hook: () => {},
      second_decriment_hook: () => {},

      active_value_zero_class:    "",
      active_value_nonzero_class: "",
      inactive_class:             "",

      ...params,
    }

    this.timer         = null
    this.turn          = null
    this.counter       = null
    this.zero_arrival  = null
    this.single_clocks = null

    this.reset()
  }

  initial_boot_from(i) {
    if (this.turn == null) {
      this.turn = i
      this.timer_restart()
    }
  }

  reset() {
    this.timer_stop()
    this.turn = this.params.turn // インクリメントしていく
    this.counter = 0             // turn とは異なり手数に相当する
    this.zero_arrival = false      // 片方が0になったら true になる
    this.single_clocks = Location.values.map((e, i) => new SingleClock(this, i))
    this.pause_p = false
  }

  // 切り替え
  clock_switch() {
    this.turn += 1
    this.counter += 1
    if (this.timer_active_p) {
      this.timer_restart()
    }
    this.params.clock_switch_hook()
  }

  // 時間経過
  generation_next(value) {
    if (this.pause_p) {
    } else {
      this.current.generation_next(value)
    }
  }

  // デバッグ用
  main_sec_set(main_sec) {
    this.single_clocks.forEach(e => e.main_sec = main_sec)
  }

  play_button_handle() {
    if (!this.timer) {
      this.single_clocks.forEach(e => e.variable_reset())
      this.timer_start()
    }
  }

  stop_button_handle() {
    this.timer_stop()
    this.single_clocks.forEach(e => e.variable_reset())
    this.zero_arrival = false
  }

  timer_start() {
    if (!this.timer) {
      this.timer = setInterval(() => this.generation_next(-1), 1000)
    }
  }

  timer_stop() {
    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = null
    }
  }

  timer_restart() {
    this.timer_stop()
    this.timer_start()
  }

  pause_on() {
    this.pause_p = true
  }

  pause_off() {
    this.pause_p = false
  }

  turn_wrap(v) {
    return v % Location.values.length
  }

  copy_1p_to_2p() {
    const [a, b] = this.single_clocks
    b.copy_from(a)
  }

  rule_set_all(o) {
    o = {...o}
    // o.read_sec = o.read_sec || o.initial_read_sec
    this.single_clocks.forEach(e => e.rule_set_one(o))
  }

  get timer_active_p() {
    return !!this.timer
  }

  get standby_mode_p() {
    return this.turn == null
  }

  get current() {
    return this.single_clocks[this.current_location.code]
  }

  get current_index() {
    return this.turn_wrap(this.turn)
  }

  get current_location() {
    return Location.fetch(this.current_index)
  }
}
