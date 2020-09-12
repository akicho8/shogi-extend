// setInterval を簡単に使う用
//
// Example:
//
//   data() {
//     return {
//       interval_runner: new IntervalRunner(this.callback, {interval: 0.5}), // 0.5秒毎
//     }
//   },
//   beforeDestroy() {
//     this.interval_runner.stop() // 安全のため解放
//   },
//   methods: {
//     callback() {
//     },
//   },
//
// 初回をすぐに呼ぶには？
//
//  early: true オプションをつける
//

const ONE_SECOND = 1000

export class IntervalRunner {
  constructor(callback, params = {}) {
    this.params = {
      interval: 1.0,  // 1秒毎
      early: false,   // 初回をすぐに呼ぶか？
      debug: process.env.NODE_ENV === "development",
      ...params,
    }
    this.callback = callback
    this.id = null
  }

  restart() {
    this.stop()
    this.start()
  }

  start() {
    if (this.id == null) {
      if (this.early) {
        this.__callback__()
      }
      // setInterval(this.__callback__, ...) では __callback__ のなかのスコープがインスタンスにならない
      this.id = setInterval(() => this.__callback__(), ONE_SECOND * this.params.interval)
      this.debug_log("start")
    }
  }

  stop() {
    if (this.id) {
      clearInterval(this.id)
      this.id = null
      this.debug_log("stop")
    }
  }

  // private

  __callback__() {
    this.callback()
    this.debug_log("callback")
  }
  
  debug_log(str) {
    if (this.params.debug) {
      console.log(`[${this.constructor.name}] ${str}`)
    }
  }
}
