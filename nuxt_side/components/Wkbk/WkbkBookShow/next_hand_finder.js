// 相手の指し手を求める
import { Gs } from "@/components/models/gs.js"

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
    const filtered_av = Gs.ary_compact_blank(av)
    if (Gs.present_p(filtered_av)) {
      let v
      switch (this.options.behavior) {
        case "first":
          v = filtered_av[0]
          break
        case "last":
          v = filtered_av[filtered_av.length - 1]
          break
        case "most_short":
          v = filtered_av.sort((a, b) => a.distance - b.distance)[0]
          break
        case "most_long":
          v = filtered_av.sort((a, b) => b.distance - a.distance)[0]
          break
        case "random":
          v = Gs.ary_sample(filtered_av)
          break
        default:
          throw new Error("must not happen")
      }
      return v.next
    }
  }

  next_hand(moves) {
    const index = this.inputs.findIndex((e, i) => moves[i] !== e) // 異なる要素を探す
    if (index === -1) {
      // 異なる要素がなかった = 途中まで正解していた
      const size = this.inputs.length + 1
      if (size <= moves.length) {          // その次の手があるか？
        const found = moves.slice(0, size) // あるなら1手進めた手をまでを取得する
        return {
          next: moves.slice(0, size),
          distance: moves.length,
        }
      }
    }
  }
}

// new NextHandFinder([["a", "b", "c", "d"]], []).call()          // => ["a"]
// new NextHandFinder([["a", "b", "c", "d"]], ["a"]).call()         // => ["a", "b"]
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "b"]).call()       // => ["a", "b", "c"]
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "b", "c"]).call()     // => ["a", "b", "c", "d"]
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "b", "c", "d"]).call()   // => null
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "b", "c", "d", "e"]).call() // => null
// new NextHandFinder([["a", "b", "c", "d"]], ["x"]).call()         // => null
// new NextHandFinder([["a", "b", "c", "d"]], ["a", "x"]).call()       // => null
//
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "first" }).call()      // => ["a", "x"]
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "last" }).call()       // => ["a", "y"]
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "most_short" }).call() // => ["a", "x"]
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "most_long" }).call()  // => ["a", "y"]
// new NextHandFinder([["a", "x"], ["a", "y", "z"]], ["a"], { behavior: "random" }).call()     // => ["a", "x"]
