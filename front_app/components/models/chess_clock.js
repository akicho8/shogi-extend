import { SingleClock } from "./single_clock.js"
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

  play_handle() {
    if (!this.running_p) {
      this.running_p = true
      this.counter = 0
      this.single_clocks.forEach(e => e.variable_reset())
      this.timer_start()
    }
  }

  stop_handle() {
    if (this.running_p) {
      this.running_p = false
      this.timer_stop()
      this.single_clocks.forEach(e => e.variable_reset())
      this.zero_arrival = false
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  pause_handle() {
    this.timer_stop()
  }

  resume_handle() {
    this.timer_start()
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

  get timer_to_css_class() {
    if (this.timer) {
      return "is_pause_off"
    } else {
      return "is_pause_on"
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

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

  get human_status() {
    let v = null
    if (this.running_p) {
      if (this.timer) {
        v = "動作中"
      } else {
        v = "一時停止中"
      }
    } else {
      v = "停止中"
    }
    return v
  }

  //////////////////////////////////////////////////////////////////////////////// for serialize

  // foo.attributes = bar.attributes
  get attributes() {
    let v = {}

    v.single_clocks = this.single_clocks.map(e => e.attributes)

    v.params = {
      initial_main_sec:  this.params.initial_main_sec,  // 持ち時間(初期値)
      initial_read_sec:  this.params.initial_read_sec,  // 秒読み(初期値)
      initial_extra_sec: this.params.initial_extra_sec, // 猶予(初期値)
      every_plus:        this.params.every_plus,        // 1手ごと加算
    }

    v.timer         = this.timer         // null以外ならタイマー動作中
    v.turn          = this.turn          // 0または1が手番。null:手番が設定されていない
    v.counter       = this.counter       // 手数 (未使用)
    v.zero_arrival  = this.zero_arrival  // 0 になったら true
    v.running_p     = this.running_p     // true:動作中 false:停止中
    v.speed         = this.speed         // タイマー速度

    return v
  }

  set attributes(v) {
    this.timer_stop()

    Object.assign(this.params, v.params)

    this.turn          = v.turn
    this.counter       = v.counter
    this.zero_arrival  = v.zero_arrival
    this.running_p     = v.running_p
    this.speed         = v.speed

    v.single_clocks.forEach((e, i) => this.single_clocks[i].attributes = e)

    if (v.timer) {
      this.timer_start()
    }
  }
}
