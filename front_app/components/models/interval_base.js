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
export class IntervalBase {
  static id_next() {
    // if (this.generation == null) {
    //   this.generation = 0
    // }
    const v = this.generation
    this.generation += 1
    return v
  }

  constructor(callback, params = {}) {
    this.params = {...this.default_params(), ...params}
    this.name = this.params.name || IntervalBase.id_next()
    this.callback = callback
    this.id = null
    this.debug_log("initialize")
  }

  default_params() {
    return {
      debug: process.env.NODE_ENV === "development",
    }
  }

  restart() {
    this.stop()
    this.start()
  }

  start() {
    if (this.id === null) {
      // setInterval(this.__callback__, ...) では __callback__ のなかのスコープがインスタンスにならない
      this.__interval_on__()
      this.debug_log("start")
    } else {
      this.debug_log("start (skip)")
    }
  }

  stop() {
    if (this.id) {
      this.debug_log("stop")
      this.__interval_off__()
      this.id = null
    } else {
      this.debug_log("stop (skip)")
    }
  }

  // private

  __interval_on__() {
    console.warn("not implemented")
    this.id = 1
  }

  __interval_off__() {
    console.warn("not implemented")
  }

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

IntervalBase.generation = 0 // TODO: 中で定義するには？
