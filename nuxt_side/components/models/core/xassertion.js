export const Xassertion = {
  __assert__(value, message = null) {
    if (!value) {
      console.error(`${value}: ${message}`)
      this.__assert_show__(message)
    }
  },

  __assert_equal__(expected, actual, message = null) {
    if (actual !== expected) {
      console.error(`<${expected}> expected but was <${actual}>`)
      this.__assert_show__(message)
    }
  },

  __assert_kind_of_integer__(value, message = null) {
    this.__assert__(Number.isInteger(value))
  },

  __assert_kind_of_string__(value, message = null) {
    this.__assert_equal__("string", typeof value, message)
  },

  __assert_kind_of_array__(value, message = null) {
    this.__assert_equal__("array", typeof value, message)
  },

  __assert_kind_of_hash__(value, message = null) {
    this.__assert_equal__("object", typeof value, message)
  },

  __assert_kind_of_object__(value, message = null) {
    this.__assert_equal__("object", typeof value, message)
  },

  __assert_nonzero__(v, message = "divided by 0") {
    this.__assert__(v !== 0, message)
  },

  // private

  __assert_show__(message = null) {
    message = message || "ぶっこわれました"
    if (typeof window !== 'undefined') {
      alert(message)
    } else {
      throw new Error(message)
    }
    debugger
  },
}
