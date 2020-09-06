const ONE_SECOND = 1000

export class IntervalRunner {
  constructor(callback, params = {}) {
    this.params = {
      interval: 1,
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
      this.id = setInterval(this.callback, ONE_SECOND * this.params.interval)
    }
  }

  stop() {
    if (this.id) {
      clearInterval(this.id)
      this.id = null
    }
  }
}
