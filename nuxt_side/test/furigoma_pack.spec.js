// お手上げ

// FAIL test/furigoma_pack.spec.js
//   ● Test suite failed to run
//
//     /Users/ikeda/src/shogi-extend/nuxt_side/node_modules/shogi-player/components/models/soldier.js:1
//     ({"Object.<anonymous>":function(module,exports,require,__dirname,__filename,global,jest){import Vue from "vue"
//                                                                                                     ^^^
//
//     SyntaxError: Unexpected identifier
//
//       1 | import { Gs } from '@/components/models/gs.js'
//     > 2 | import { Soldier } from "./../../node_modules/shogi-player/components/models/soldier.js" // FIXME: テストで読み込めない。修正方法不明。
//         | ^
//       3 | import { Piece } from "shogi-player/components/models/piece.js"
//       4 | import _ from "lodash"
//       5 |
//
//       at Runtime.createScriptFromCode (node_modules/jest-runtime/build/index.js:1295:14)
//       at Object.<anonymous> (components/models/furigoma_pawn.js:2:1)
//
// Test Suites: 1 failed, 1 total
// Tests:       0 total
// Snapshots:   0 total
// Time:        2.493 s
// Ran all test suites matching /furigoma_pack.spec.js/i.

import { FurigomaPack } from '@/components/models/furigoma_pack.js'

describe('FurigomaPack', () => {
  test('works', () => {
    // console.log((new FurigomaPack()).inspect)
  })
})
