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

import { IntervalBase } from "./IntervalBase.js"

export class IntervalRunner extends IntervalBase {
  default_params() {
    return {
      ...super.default_params(),
      interval: 1.0,  // 1秒毎
      early: false,   // 初回をすぐに呼ぶか？
    }
  }

  __interval_on__() {
    if (this.params.early) {
      this.__callback__()
    }
    this.id = setInterval(() => this.__callback__(), ONE_SECOND * this.params.interval)
  }

  __interval_off__() {
    clearInterval(this.id)
  }
}
