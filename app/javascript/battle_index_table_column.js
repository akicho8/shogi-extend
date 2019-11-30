import _ from "lodash"

export default {
  data() {
    return {
      table_columns_hash: this.$options.table_columns_hash,
    }
  },

  created() {
    if (this.table_column_storage_key) {
      console.log("table_column_storage_key", this.table_column_storage_key)

      // localStorage.removeItem(this.table_column_storage_key)

      console.log("反映前")
      console.table(this.simple_table_columns_hash_for_storage)

      const hash = this.storage_load_visible_columns_hash()
      if (hash) {
        _.each(this.table_columns_hash, (v, k) => {
          v.visible = !!hash[k]
        })
      }
    }
  },

  watch: {
    simple_table_columns_hash_for_storage(v) {
      if (this.table_column_storage_key) {
        console.log("save")
        console.table(v)
        localStorage.setItem(this.table_column_storage_key, JSON.stringify(v))
      }
    },
  },

  methods: {
    storage_load_visible_columns_hash() {
      if (this.table_column_storage_key) {
        const str = localStorage.getItem(this.table_column_storage_key)
        if (str) {
          const v = JSON.parse(str)
          console.log("load")
          console.table(v)
          return v
        }
      }
    },
  },

  computed: {
    // 表示している列のカラム名の配列
    visible_columns() {
      const ary = _.map(this.table_columns_hash, (attrs, key) => {
        if (attrs.visible) {
          return key
        }
      })
      return _.compact(ary)
    },

    // private

    // ストレージに保存する用のハッシュ
    // {a: true, b: false} 形式
    simple_table_columns_hash_for_storage() {
      return _.reduce(this.table_columns_hash, (a, e) => ({...a, [e.key]: e.visible}), {})
    },

    table_column_storage_key() {
      const key = this.$options.table_column_storage_prefix_key
      if (key) {
        return [key, "table_column_storage_key"].join("_")
      }
    },
  },
}
