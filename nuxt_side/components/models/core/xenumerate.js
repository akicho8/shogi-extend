export const Xenumerate = {
  n_times(n, block) {
    for (let i = 0; i < n; i++) {
      block(i)
    }
  },

  n_times_collect(n, block) {
    const ary = []
    for (let i = 0; i < n; i++) {
      ary.push(block(i))
    }
    return ary
  },
}
