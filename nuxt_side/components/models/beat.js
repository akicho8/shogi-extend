export const Beat = {
  call_short() {
    this.call_custom(10)
  },

  call_middle() {
    this.call_custom(100)
  },

  call_long() {
    this.call_custom([
      50, 200, 100, 50,
      50, 200, 100, 50,
      50,
    ])
  },

  call_custom(argv) {
    if (!this.support_p()) {
      return
    }

    window.navigator.vibrate(argv)
  },

  // private

  support_p() {
    if (typeof window !== 'undefined') {
      return !!window.navigator.vibrate
    }
  },
}
