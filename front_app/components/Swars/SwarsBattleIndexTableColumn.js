import _ from "lodash"

export default {
  data() {
    return {
      visible_hash: null, //  { xxx: true, yyy: false } 形式
    }
  },

  methods: {
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
  },

  computed: {
    // 表示している列のカラム名の配列
    // { xxx: true, yyy: false } -> [xxx]
    visible_only_keys() {
      const ary = _.map(this.visible_hash, (value, key) => {
        if (value) {
          return key
        }
      })
      return _.compact(ary)
    },
  },
}
