export const Vibrator = {
  vibrate_support_p() {
    if (typeof window !== 'undefined') {
      return !!window.navigator.vibrate
    }
  },

  vibrate(argv) {
    if (!this.vibrate_support_p()) {
      return
    }

    window.navigator.vibrate(argv)
  },

  vibrate_short() {
    this.vibrate(10)
  },

  vibrate_middle() {
    this.vibrate(100)
  },

  vibrate_long() {
    this.vibrate([
      50, 200, 100, 50,
      50, 200, 100, 50,
      50,
    ])
  },
}
