export const DeviseAngle = {
  value() {
    let v = screen && screen.orientation && screen.orientation.angle
    if (v == null) {
      v = window.orientation || 0
    }
    return v
  },

  // 横か？
  portrait_p() {
    return this.value() === 0
  },

  // 縦か？
  landscape_p() {
    return !this.portrait_p()
  },
}
