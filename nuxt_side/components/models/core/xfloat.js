import _ from "lodash"

export const Xfloat = {
  number_floor(v, precision = 0) {
    return _.floor(v, precision)
  },

  number_ceil(v, precision = 0) {
    return _.ceil(v, precision)
  },

  number_round(v, precision = 0) {
    return _.round(v, precision)
  },

  // number_round_s(3.000, 1) // => "3.0"
  // number_round_s(3.456, 1) // => "3.5"
  number_round_s(v, precision = 0) {
    return v.toFixed(precision)
  },

  number_truncate(v, precision = 0) {
    const base = Math.pow(10, precision)
    return Math.trunc(v * base) / base
  },

  // floatx100_percentage(0.33, 2)    // => 33
  // floatx100_percentage(0.333, 2)   // => 33.3
  // floatx100_percentage(0.33333, 2) // => 33.33
  floatx100_percentage(v, precision = 0) {
    return this.number_floor(v * 100, precision)
  },
}
