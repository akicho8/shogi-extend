import { SingleClock } from "./SingleClock.js"
import { Location } from "shogi-player/components/models/location.js"

export class ChessClock {
  constructor(params = {}) {
    this.params = {
      // ここらのハッシュキーはリアクティブにするため null でも定義が必要
      initial_main_sec:  null,  // 持ち時間(初期値)
      initial_read_sec:  null,  // 秒読み(初期値)
      initial_extra_sec: null,  // 猶予(初期値)
      every_plus:        null,  // 1手ごと加算

      time_zero_callback: e => {},
      clock_switch_hook: () => {},
      second_decriment_hook: () => {},

      active_value_zero_class:    "",
      active_value_nonzero_class: "",
      inactive_class:             "",

      ...params,
    }

    this.timer         = null   // null以外ならタイマー動作中
    this.turn          = null   // 0または1が手番。null:手番が設定されていない
    this.counter       = null   // 手数 (未使用)
    this.zero_arrival  = null   // 0 になったら true
    this.single_clocks = null   // それぞれの時計
    this.running_p     = null   // true:動作中 false:停止中

    this.speed = 1.0

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
    this.zero_arrival = false    // 片方が0になったら true になる
    this.single_clocks = Location.values.map((e, i) => new SingleClock(this, i))
    this.running_p = false
  }

  // 切り替え
  clock_switch() {
    this.turn += 1
    this.counter += 1
    if (this.timer) {
      this.timer_restart()
    }
    this.params.clock_switch_hook()
  }

  // 時間経過
  generation_next(value) {
    if (this.timer) {
      this.current.generation_next(value)
    }
  }

  // デバッグ用
  main_sec_set(main_sec) {
    this.single_clocks.forEach(e => e.main_sec = main_sec)
  }

  play_button_handle() {
    if (!this.running_p) {
      this.running_p = true
      this.counter = 0
      this.single_clocks.forEach(e => e.variable_reset())
      this.timer_start()
    }
  }

  stop_button_handle() {
    if (this.running_p) {
      this.running_p = false
      this.timer_stop()
      this.single_clocks.forEach(e => e.variable_reset())
      this.zero_arrival = false
    }
  }

  timer_start() {
    if (!this.timer) {
      this.timer = setInterval(() => this.generation_next(-1), 1000 / this.speed)
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
    if (this.timer)
    this.timer_stop()
  }

  pause_off() {
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
    this.single_clocks.forEach(e => e.rule_set_one(o))
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
