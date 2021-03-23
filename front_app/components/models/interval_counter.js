// setInterval を簡単に使う用
//
// Example:
//
//   data() {
//     return {
//       interval_counter: new IntervalCounter(this.callback, {interval: 0.5}), // 0.5秒毎
//     }
//   },
//   beforeDestroy() {
//     this.interval_counter.stop() // 安全のため解放
//   },
//   methods: {
//     callback(counter) {
//       console.log(counter)
//     },
//   },
//

import { IntervalRunner } from "./interval_runner.js"

export class IntervalCounter extends IntervalRunner {
  constructor(callback, params = {}) {
    super(callback, params) // TODO: 引数をそのまま渡す方法は？
    this.counter_reset()
  }

  counter_reset() {
    this.counter = this.params.initial
  }

  default_params() {
    return {
      ...super.default_params(),
      initial: 0, // カウンター初期値
    }
  }

  start() {
    if (this.id === null) {
      this.counter_reset()
      super.start()
    }
  }

  __callback__() {
    this.debug_log(`callback(${this.counter})`)
    this.callback(this.counter)
    this.counter += 1
  }
}
