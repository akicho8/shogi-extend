import _ from "lodash"

export default {
  data() {
    return {
      table_columns_hash: this.config.table_columns_hash,
      visible_hash: null,       //  { xxx: true, yyy: false } 形式
    }
  },

  methods: {
    // { xxx: true, yyy: false } 形式に変換
    as_visible_hash(v) {
      return _.reduce(v, (a, e) => ({...a, [e.key]: e.visible}), {})
    },
  },

  computed: {
    // 表示している列のカラム名の配列
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
