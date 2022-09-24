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
      return null
    }
    return value
  },

  p(value) {
    console.log(value)
  },

  pp(value) {
    console.log(JSON.stringify(value))
  },

  i(value) {
    return JSON.stringify(value)
  },

  a(value) {
    alert(this.i(value))
  },
}
