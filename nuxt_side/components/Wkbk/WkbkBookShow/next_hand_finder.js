// 相手の指し手を求める
import { GX } from "@/components/models/gx.js"

export class NextHandFinder {
  constructor(list_of_moves, inputs, options = {}) {
    this.options = {
      behavior: "most_long",
      ...options,
    }
    this.list_of_moves = list_of_moves
    this.inputs = inputs
  }

  call() {
    const av = this.list_of_moves.map(moves => this.next_hand(moves))
    const filtered_av = GX.ary_compact(av)
    if (GX.present_p(filtered_av)) {
      let v
      switch (this.options.behavior) {
        case "order_first":
          v = GX.ary_first(filtered_av)
          break
        case "order_last":
          v = GX.ary_last(filtered_av)
          break
        case "most_short":
          v = this.most_short_or_most_long(filtered_av, 1)
          break
        case "most_long":
          v = this.most_short_or_most_long(filtered_av, -1)
          break
        case "random":
          v = GX.ary_sample(filtered_av)
          break
        default:
          throw new Error("must not happen")
      }
      return v.next
    }
  }

  most_short_or_most_long(av, direction) {
    const sorted = GX.ary_sort_by(av, e => e.distance * direction)
    const distance = GX.ary_first(sorted).distance
    const valid_hands = GX.ary_find_all(sorted, e => e.distance === distance)
    return GX.ary_sample(valid_hands)
  }

  next_hand(moves) {
    const taked_moves = GX.ary_take(moves, this.inputs.length) // 途中まで
    const same = GX.equal_p(taked_moves, this.inputs)          // 一致する？
    if (same) {
      const size = this.inputs.length + 1
      if (size <= moves.length) {          // その次の手があるか？
        return {
          next: GX.ary_take(moves, size),  // あるなら1手進めた手をまでを取得する
          distance: moves.length,
        }
      }
    }
  }
}

// new NextHandFinder([["a", "b", "c", "d"]], []).call()                                        // => ["a"]
// new NextHandFinder([["a", "b", "c", "d"]], ["a"]).call()                                     // => ["a", "b"]
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "b"]).call()                                // => ["a", "b", "c"]
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "b", "c"]).call()                           // => ["a", "b", "c", "d"]
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "b", "c", "d"]).call()                      // => null
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "b", "c", "d", "e"]).call()                 // => null
// new NextHandFinder([["a", "b", "c", "d"]], ["x"]).call()                                     // => null
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "x"]).call()                                // => null
//
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "order_first" }).call() // => ["a", "x"]
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "order_last" }).call()  // => ["a", "y"]
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "most_short" }).call()  // => ["a", "x"]
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "most_long" }).call()   // => ["a", "y"]
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "random" }).call()      // => ["a", "x"]
