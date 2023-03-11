const util = require("util")

export const Xobject = {
  // lodash の _.isEmpty は不自然な挙動なので使ってはいけない
  blank_p(value) {
    return value === undefined || value === null || value === false ||
      (typeof value === "object" && Object.keys(value).length === 0) ||
      (typeof value === "string" && value.trim().length === 0)
  },

  present_p(value) {
    return !this.blank_p(value)
  },

  presence(value) {
    if (this.blank_p(value)) {
      return undefined          // null だとURLのパラメータが消えないため undefined にする
    }
    return value
  },

  p(value) {
    console.log(value)
  },

  pp(value) {
    console.log(util.inspect(value))
  },

  short_inspect(value) {
    return util.inspect(value)
  },

  i(value) {
    return util.inspect(value)
  },

  pretty_inspect(value) {
    return JSON.stringify(value, null, 4)
  },

  a(value) {
    alert(this.i(value))
  },

  // async func() {
  //   await Xobject.sleep(1)
  // }
  sleep(second) {
    return new Promise(resolve => setTimeout(resolve, second * 1000))
  },
}
