// requestAnimationFrame を簡単に使う用
//
// Example:
//
//   data() {
//     return {
//       interval_runner: new IntervalFrame(this.callback, {interval: 0.5, name: "main"}), // 0.5秒毎
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

import { IntervalBase } from "./interval_base.js"

export class IntervalFrame extends IntervalBase {
  __interval_on__() {
    let start = window.performance.now()
    const loop = () => {
      const now = window.performance.now()
      const micro_sec = now - start
      if (this.params.debug) {
        this.debug_log(`callback(${micro_sec})`)
      }
      this.callback(micro_sec)
      start = now
      this.id = window.requestAnimationFrame(loop)
    }
    loop()
  }

  __interval_off__() {
    window.cancelAnimationFrame(this.id)
  }
}
