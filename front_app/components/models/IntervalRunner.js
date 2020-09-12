// setInterval を簡単に使う用
//
// Example:
//
//   data() {
//     return {
//       interval_runner: new IntervalRunner(this.callback, {interval: 0.5, name: "main"}), // 0.5秒毎
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
// ログの見方は？
//
//   [IntervalCounter][名前][タイマーID] 動作
//
//   [IntervalCounter][0][45] start
//   [IntervalCounter][0][45] callback(0)
//   [IntervalCounter][0][45] callback(1)
//   [IntervalCounter][0][45] callback(2)
//   [IntervalCounter][0][45] callback(3)
//   [IntervalCounter][0][45] stop
//   [IntervalCounter][0][] stop (skip)
//
const ONE_SECOND = 1000

export class IntervalRunner {
  static id_next() {
    // if (this.generation == null) {
    //   this.generation = 0
    // }
    const v = this.generation
    this.generation += 1
    return v
  }

  constructor(callback, params = {}) {
    this.params = {
      interval: 1.0,  // 1秒毎
      early: false,   // 初回をすぐに呼ぶか？
      debug: process.env.NODE_ENV === "development",
      ...params,
    }
    this.name = this.params.name || IntervalRunner.id_next()
    this.callback = callback
    this.id = null
    this.debug_log("initialize")
  }

  restart() {
    this.stop()
    this.start()
  }

  start() {
    if (this.id == null) {
      if (this.params.early) {
        this.__callback__()
      }
      // setInterval(this.__callback__, ...) では __callback__ のなかのスコープがインスタンスにならない
      this.id = setInterval(() => this.__callback__(), ONE_SECOND * this.params.interval)
      this.debug_log("start")
    } else {
      this.debug_log("start (skip)")
    }
  }

  stop() {
    if (this.id) {
      this.debug_log("stop")
      clearInterval(this.id)
      this.id = null
    } else {
      this.debug_log("stop (skip)")
    }
  }

  // private

  __callback__() {
    this.callback()
    this.debug_log("callback")
  }

  debug_log(str) {
    if (this.params.debug) {
      console.log(`[${this.constructor.name}][${this.name}][${this.id || ''}] ${str}`)
    }
  }
}

IntervalRunner.generation = 0 // TODO: 中で定義するには？
