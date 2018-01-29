document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: "#xy_game_app",
    data: {
      boardSize: 9,
      mode: "ready",
      currentX: null,
      currentY: null,
      answerdCount: null,
      okCount: 0,
      ngCount: 0,
      inputKeys: null,
      timerRun: false,
      timerCount: null,
      limitSeconds: 10,
      error: 0,
      piece: null,
      location: null,
    },

    created: function() {
      let start = window.performance.now()
      const loop = () => {
        const now = window.performance.now()
        if (this.timerRun) {
          this.timerCount += Math.floor(now - start)
        }
        start = now
        window.requestAnimationFrame(loop)
      }
      loop()
    },

    watch: {
      timerCount: function() {
        if (this.restTime <= 0) {
          this.mode = "goal"
          this.timerRun = false
        }
      }
    },

    computed: {
      restTime: function() {
        let v = (this.limitSeconds * 1000) - this.timerCount
        if (v < 0) {
          v = 0
        }
        return v
      },

      timeFormat: function() {
        const mm = Math.floor(this.restTime / 1000 / 60).toString().padStart(2, "0")
        const ss = Math.floor(this.restTime / 1000 % 60).toString().padStart(2, "0")
        const ms = Math.floor(this.restTime % 1000 / 10).toString().padStart(2, "0")
        return `${mm}:${ss}:${ms}`
      },
    },

    methods: {
      enterFunc (e) {
        if (this.mode != "running") return
        this.inputKeys.push(e.key)
        if (this.inputKeys.length >= 2) {
          const x = parseInt(this.inputKeys.shift())
          const y = parseInt(this.inputKeys.shift())
          if (this.isActive(this.boardSize - x, y - 1)) {
            this.okCount++
            this.error = 0
          } else {
            this.ngCount++
            this.error++
          }
          this.answerdCount++
          this.reset()
        }
      },

      readyGo () {
        this.timerRun = true
        this.timerCount = 0
        this.answerdCount = 0
        this.okCount = 0
        this.ngCount = 0
        this.error = 0
        this.inputKeys = []
        document.addEventListener("keypress", this.enterFunc)
        this.mode = "running"
        this.reset()
      },

      reset () {
        this.currentX = this.posRandom()
        this.currentY = this.posRandom()
        this.piece = this.pieceRandom()
        if (this.rand(2) == 0) {
          this.location = "black"
        } else {
          this.location = "white"
        }
      },

      cellClass (x, y) {
        let str = null
        if (this.isActive(x, y)) {
          str = ["current", `location_${this.location}`]
        }
        return str
      },

      isActive (x, y) {
        return this.currentX == x && this.currentY == y
      },

      posRandom () {
        return this.rand(this.boardSize)
      },

      pieceRandom () {
        const chars = "玉飛龍角馬金銀全桂圭香杏歩と".split("")
        return chars[this.rand(chars.length)]
      },

      rand (n) {
        return Math.floor(Math.random() * n)
      }
    },
  })
})
