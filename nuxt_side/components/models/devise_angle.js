export const DeviseAngle = {
  // 縦か？
  portrait_p() {
    return this.value() === 0
  },

  // 横か？
  landscape_p() {
    return !this.portrait_p()
  },

  // private

  value() {
    let v = screen && screen.orientation && screen.orientation.angle
    if (v == null) {
      v = window.orientation || 0
    }
    return v
  },
}
