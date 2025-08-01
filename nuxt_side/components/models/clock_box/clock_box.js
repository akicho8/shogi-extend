import { SingleClock } from "./single_clock.js"
import { Location } from "shogi-player/components/models/location.js"
import { Gs } from "@/components/models/gs.js"
import dayjs from "dayjs"

const HUMAN_STATUS_LABELS = {
  play:  "動作中",
  pause: "一時停止中",
  stop:  "停止中",
}

// 一時停止中の時間を管理する
const PauseTimerMethods = {
  // public
  get pause_sec_human() {
    if (this.pause_timer) {
      return dayjs().startOf("year").set("seconds", this.pause_sec).format("m:ss")
    }
  },

  // private

  pause_var_init() {
    this.pause_sec = 0
  },

  pause_tick() {
    this.pause_sec += 1
    this.pause_tick_user_callback()
  },

  pause_tick_user_callback() {
    const [mm, ss] = Gs.idivmod(this.pause_sec, 60)
    this.params.pause_tick_fn(mm, ss)
  },

  pause_timer_start() {
    if (this.pause_timer == null) {
      this.pause_timer = setInterval(() => this.pause_tick(), 1000 / this.speed)
    }
  },

  pause_timer_stop() {
    if (this.pause_timer) {
      clearTimeout(this.pause_timer)
      this.pause_timer = null
    }
  },

  pause_timer_restart() {
    this.pause_timer_stop()
    this.pause_timer_start()
  },
}

export class ClockBox {
  constructor(params = {}) {
    Object.defineProperties(this, Object.getOwnPropertyDescriptors(PauseTimerMethods)) // Ruby でいうところの extend

    this.params = {
      // ここらのハッシュキーはリアクティブにするため null でも定義が必要
      initial_main_sec:  null,  // 持ち時間(初期値)
      initial_read_sec:  null,  // 秒読み(初期値)
      initial_extra_sec: null,  // 猶予(初期値)
      every_plus:        null,  // 1手ごと加算

      time_zero_fn:        () => {}, // 残り時間が 0 になったときの処理 (切れ負け/勝ち判定用)
      switched_fn:         () => {}, // 時計を切り替えた瞬間の処理 (用途不明)
      second_decriment_fn: () => {}, // 時間が減るたびに呼ぶ処理 (主に秒読み用)
      read_koreyori_fn:    () => {}, // 「これより1手N秒でお願いします」と言いたい場合の処理
      extra_koreyori_fn:   () => {}, // 「深考時間が0になったら負けです」と言いたい場合の処理
      pause_tick_fn:       () => {}, // 一時停止中に「1分経過」と言いたい場合の処理

      active_value_zero_css_class:    "",
      active_value_nonzero_css_class: "",
      inactive_css_class:             "",

      initial_turn: null,

      ...params,
    }

    this.timer           = null   // null以外ならタイマー動作中 (nullで一時停止)
    this.turn            = null   // 0または1が手番。null:手番が設定されていない。順番ではなく 0:黒 1:白 と決まっているため駒落ちの場合1にすること
    this.single_clocks   = null   // それぞれの時計

    // _var_init で初期値を入れる
    this.pause_or_play_p = null   // [PLAY] で true になり [STOP] で false になる
    this.play_count      = null   // stop で 0 になり play のたびに +1
    this.pause_count     = null   // stop で 0 になり pause のたびに +1
    this.resume_count    = null   // stop で 0 になり resume のたびに +1
    this.switch_count    = null   // 時計を切り替えた回数
    this.elapsed_sec     = null   // 直近の経過時間

    this.speed = 1.0

    this.pause_timer = null   // ポーズ時のタイマー
    this.pause_sec   = null   // ポーズ時の経過秒数

    this.reset()
  }

  // 未使用
  // initial_boot_from(i) {
  //   if (this.turn == null) {
  //     this.turn = i
  //     this.timer_restart()
  //   }
  // }

  reset() {
    this.timer_stop()
    this.pause_timer_stop()
    if (this.params.initial_turn != null) {
      this.turn = this.params.initial_turn
    }
    this.single_clocks = Location.values.map((e, i) => new SingleClock(this, i))
    this._var_init()
  }

  _var_init() {
    this.pause_or_play_p = false
    this.play_count = 0
    this.pause_count = 0
    this.resume_count = 0
    this.switch_count = 0
    this.elapsed_sec = 0

    this.pause_var_init()
  }

  // 切り替え
  clock_switch() {
    Gs.assert(this.turn != null, "this.turn != null")
    this.turn += 1
    this.switch_count += 1
    this.elapsed_sec = 0
    if (this.timer) {
      this.timer_restart()
    }
    this.params.switched_fn()
  }

  // location 側のボタンを押す
  tap_on(location) {
    this.single_clocks[Location.fetch(location).code].tap_on()
  }

  // location 側のターンに強制変更
  // これは1手戻すなどのときに使う
  location_to(location) {
    this.current.rebirth() // 戻るときに今のターンの人が損にならないように秒読みを戻してあげる(フィッシャー分も加算)
    this.turn = Location.fetch(location).code
  }

  // 時間経過
  generation_next(value) {
    this.elapsed_sec += value
    this.current.generation_next(value)
  }

  // 1回分進む
  tick() {
    this.generation_next(-1)
  }

  // デバッグ用
  main_sec_set(main_sec) {
    this.single_clocks.forEach(e => e.main_sec = main_sec)
  }

  play_handle() {
    if (!this.pause_or_play_p) {
      this.pause_or_play_p = true
      this.play_count += 1
      this.single_clocks.forEach(e => e.variable_reset())
      this.timer_start()
    }
  }

  stop_handle() {
    if (this.pause_or_play_p) {
      this.timer_stop()
      this.pause_timer_stop()
      this._var_init()
      this.single_clocks.forEach(e => e.variable_reset())
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  pause_handle() {
    if (this.timer) {
      this.timer_stop()

      this.pause_var_init()
      this.pause_timer_start()

      this.pause_count += 1
    }
  }

  resume_handle() {
    if (this.timer == null) {
      this.timer_start()

      this.pause_timer_stop()
      this.pause_var_init()

      this.resume_count += 1
    }
  }

  timer_start() {
    if (this.timer == null) {
      this.timer = setInterval(() => this.tick(), 1000 / this.speed)
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
    Gs.assert(v != null, "v != null")
    return v % Location.values.length
  }

  copy_1p_to_2p() {
    const [a, b] = this.single_clocks
    b.copy_from(a)
  }

  rule_set_all(o) {
    this.single_clocks.forEach(e => e.rule_set_one(o))
  }

  rule_set_all_by_ary(ary) {
    this.single_clocks.forEach((e, i) => e.rule_set_one(ary[i]))
  }

  get current() {
    return this.single_clocks[this.current_location.code]
  }

  get opponent() {
    return this.single_clocks[this.current_location.flip.code]
  }

  get current_index() {
    return this.turn_wrap(this.turn)
  }

  get current_location() {
    return Location.fetch(this.current_index)
  }

  // どちらかの時間が0になっている？
  get any_zero_p() {
    return this.single_clocks.some(e => e.rest <= 0)
  }

  //////////////////////////////////////////////////////////////////////////////// 状態

  get stop_or_pause_p() {
    return this.stop_p || this.pause_p
  }
  get pause_p() {
    return this.current_status === "pause"
  }
  get play_p() {
    return this.current_status === "play"
  }
  get stop_p() {
    return this.current_status === "stop"
  }
  get human_status() {
    return HUMAN_STATUS_LABELS[this.current_status]
  }
  get current_status() {
    let v = null
    if (this.pause_or_play_p) {
      if (this.timer) {
        v = "play"
      } else {
        v = "pause"
      }
    } else {
      v = "stop"
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

    v.timer           = this.timer           // null以外ならタイマー動作中
    v.turn            = this.turn            // 0または1が手番。null:手番が設定されていない
    v.pause_or_play_p = this.pause_or_play_p // true:動作中 false:停止中
    v.play_count      = this.play_count      // play で +1
    v.pause_count     = this.pause_count
    v.resume_count    = this.resume_count    // resume で +1
    v.switch_count    = this.switch_count    // 時計を切り替えた回数
    v.elapsed_sec     = this.elapsed_sec
    v.speed           = this.speed           // タイマー速度

    v.pause_timer     = this.pause_timer       // ポーズ時のタイマー
    v.pause_sec       = this.pause_sec         // ポーズ時の経過秒数

    return v
  }

  set attributes(v) {
    this.timer_stop()
    this.pause_timer_stop()
    this.attributes_copy_from(v)
    if (v.timer) {
      this.timer_start()
    }
    if (v.pause_timer) {
      this.pause_timer_start()
    }
  }

  attributes_copy_from(v) {
    Object.assign(this.params, v.params)

    this.turn            = v.turn
    this.pause_or_play_p = v.pause_or_play_p
    this.play_count      = v.play_count
    this.pause_count     = v.pause_count
    this.resume_count    = v.resume_count
    this.switch_count    = v.switch_count
    this.elapsed_sec     = v.elapsed_sec
    this.speed           = v.speed

    this.pause_sec       = v.pause_sec

    v.single_clocks.forEach((e, i) => this.single_clocks[i].attributes = e)
  }

  // 内容をコピーした(まだ動作していない)新しいインスタンスを返す
  get duplicate() {
    const instance = new this.constructor()
    instance.attributes_copy_from(this.attributes)
    return instance
  }
}
