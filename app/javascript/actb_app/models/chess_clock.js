import { SingleClock } from "./single_clock.js"
import Location from "shogi-player/src/location.js"

export class ChessClock {
  constructor(params = {}) {
    this.params = {
      // ここらのハッシュキーはリアクティブにするため null でも定義が必要
      turn: null,
      range_low: null,
      every_plus: null,
      delay_second: null,

      time_zero_callback: e => {},
      clock_switch_hook: () => {},
      second_decriment_hook: () => {},

      active_value_zero_class:     "has-text-danger",
      active_value_nonzero_class: "has-text-primary",
      inactive_class:              "has-text-grey-light",

      ...params,
    }

    this.timer         = null
    this.turn          = null
    this.counter       = null
    this.zero_arrival    = null
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
    this.current.generation_next(value)
  }

  main_second_set(main_second) {
    this.single_clocks.forEach(e => e.main_second = main_second)
  }

  timer_stop2() {
    this.timer_stop()
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

  turn_wrap(v) {
    return v % Location.values.length
  }

  copy_1p_to_2p() {
    const [a, b] = this.single_clocks
    b.copy_from(a)
  }

  rule_set_all(o) {
    o = {...o}
    o.main_second = o.main_second || o.range_low
    this.single_clocks.forEach(e => e.copy_from(o))
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
