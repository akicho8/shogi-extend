import { NextHandFinder } from "@/components/Wkbk/WkbkBookShow/next_hand_finder.js"

describe("NextHandFinder", () => {
  it("基本", () => {
    expect(new NextHandFinder([['a', 'b', 'c', 'd']], []).call()).toEqual(["a"])
    expect(new NextHandFinder([['a', 'b', 'c', 'd']], ['a']).call()).toEqual(["a", "b"])
    expect(new NextHandFinder([['a', 'b', 'c', 'd']], ['a', 'b']).call()).toEqual(["a", "b", "c"])
    expect(new NextHandFinder([['a', 'b', 'c', 'd']], ['a', 'b', 'c']).call()).toEqual(["a", "b", "c", "d"])
    expect(new NextHandFinder([['a', 'b', 'c', 'd']], ['a', 'b', 'c', 'd']).call()).toEqual(undefined)
    expect(new NextHandFinder([['a', 'b', 'c', 'd']], ['a', 'b', 'c', 'd', 'e']).call()).toEqual(undefined)
    expect(new NextHandFinder([['a', 'b', 'c', 'd']], ['x']).call()).toEqual(undefined)
    expect(new NextHandFinder([['a', 'b', 'c', 'd']], ['a', 'x']).call()).toEqual(undefined)
  })
  it("複数にマッチしたときどれを選択するかオプションで調整する", () => {
    expect(new NextHandFinder([['a', 'x'], ['a', 'y', 'z']], ['a'], { behavior: 'first' }).call()).toEqual(["a", "x"])
    expect(new NextHandFinder([['a', 'x'], ['a', 'y', 'z']], ['a'], { behavior: 'last' }).call()).toEqual(["a", "y"])
    expect(new NextHandFinder([['a', 'x'], ['a', 'y', 'z']], ['a'], { behavior: 'most_short' }).call()).toEqual(["a", "x"])
    expect(new NextHandFinder([['a', 'x'], ['a', 'y', 'z']], ['a'], { behavior: 'most_long' }).call()).toEqual(["a", "y"])
    // expect(new NextHandFinder([['a', 'x'], ['a', 'y', 'z']], ['a'], { behavior: 'random' }).call()).toEqual(["a", "x"])
  })
})
