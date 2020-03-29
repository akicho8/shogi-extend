export default {
  methods: {
    // created() {
    //   this.$_ls_load()
    //   this.$watch(() => this.$_ls_watch_values, () => this.$_ls_save(), {deep: true}) // 変数がハッシュかもしれないので deep: true にしておく
    // },

    lst_save(key, value) {
      localStorage.setItem(key, JSON.stringify(value))
    },

    lst_load(key) {
      let v = {}
      const value = localStorage.getItem(key)
      if (value) {
        v = JSON.parse(value)
      }
      return v
    },

    lst_delete(key) {
      localStorage.removeItem(key)
    },

    // lst_set_vars(v) {
    //   this.lst_data_keys.forEach(e => {
    //     this[e] = (v[e] != null) ? v[e] : this.ls_data[e]
    //   })
    // },
    //
    // lst_reset() {
    //   localStorage.removeItem(this.ls_key)
    //   this.lst_load()
    // },

    // computed: {
    //   ls_key() {
    //     alert("ls_key is not implemented")
    //   },
    //
    //   ls_data() {
    //     alert("ls_data is not implemented")
    //   },
    //
    //   lst_data_keys() {
    //     return Object.keys(this.ls_data)
    //   },
    //
    //   lst_watch_values() {
    //     return this.lst_data_keys.map(e => this[e])
    //   },
    //
    //   // ハッシュ型にした保存するデータ
    //   lst_hash() {
    //     return this.lst_data_keys.reduce((a, e) => ({...a, [e]: this[e]}), {})
    //   },
  },
}
