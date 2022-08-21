const JunbanCop = {
  func(a, b, t) {
    const g = [a, b]
    const c = Math.abs(t) % g.length
    const i = Math.floor(t / g.length)
    console.log(t, c, i)
    // console.log(t, c, i, g[c][i % g[c].length])
  },
}

const a = ["a", "b"]
const b = ["c", "d", "e"]

JunbanCop.func(a, b, -9)
JunbanCop.func(a, b, -8)
JunbanCop.func(a, b, -7)
JunbanCop.func(a, b, -6)
JunbanCop.func(a, b, -5)
JunbanCop.func(a, b, -4)
JunbanCop.func(a, b, -3)
JunbanCop.func(a, b, -2)
JunbanCop.func(a, b, -1)
JunbanCop.func(a, b, 0)
JunbanCop.func(a, b, 1)
JunbanCop.func(a, b, 2)
JunbanCop.func(a, b, 3)
JunbanCop.func(a, b, 4)
JunbanCop.func(a, b, 5)
JunbanCop.func(a, b, 6)
JunbanCop.func(a, b, 7)
