import { Xenumerate } from "@/components/models/core/xenumerate.js"

describe("Xenumerate", () => {
  test("n_times_collect", () => {
    expect(Xenumerate.n_times_collect(2, e => e)).toEqual([0, 1])
  })
  test("n_times", () => {
    const ary = []
    Xenumerate.n_times(2, i => ary.push(i))
    expect(ary).toEqual([0, 1])
  })
})
