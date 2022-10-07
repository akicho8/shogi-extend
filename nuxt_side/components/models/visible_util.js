// |-----------------|
// | as_visible_hash |
// |-----------------|

import _ from "lodash"

export const VisibleUtil = {
  // シンプルなハッシュに変換
  //
  // [
  //   { key: "column1", visible: true, },
  //   { key: "column2", visible: true, },
  // ]
  //
  //   ↓
  //
  // { xxx: true, yyy: false }
  //
  as_visible_hash(v) {
    return _.reduce(v, (a, e) => ({...a, [e.key]: e.visible}), {})
  },
}
