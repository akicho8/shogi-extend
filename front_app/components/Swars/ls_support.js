// 超簡単に変数を永続化するテンプレートメソッドパターン
//
// 使う側で書くこと
//
//   import ls_support from "ls_support.js"
//
//   {
//     mixins: [ls_support],
//
//     data() {
//       return {
//         my_var1: null, // ここの値は意味ないので null でよい
//       }
//     },
//
//     computed: {
//       ls_key() {
//         return "my_app" // localStorage のキー ← デフォルトでは this.$options.name なのでそのままでもよい
//       },
//
//       ls_data() {
//         return {
//           my_var1: false, // 初期値
//         }
//       },
//     },
//   }
export default {
  methods: {
    $_ls_setup() {
      this.$_ls_load()
      // FIXME: unwatch してない
      this.$watch(() => this.$_ls_watch_values, () => this.$_ls_save(), {deep: true}) // 変数がハッシュかもしれないので deep: true にしておく
    },

    $_ls_save() {
      if (this.development_p) {
        console.log("$_ls_save", JSON.stringify(this.$_ls_hash))
      }
      this.lst_save(this.ls_key, this.$_ls_hash)
    },

    $_ls_load() {
      if (this.development_p) {
        console.log("$_ls_load", this.lst_load(this.ls_key))
      }
      this.$_ls_set_vars(this.lst_load(this.ls_key))
    },

    $_ls_set_vars(hash) {
      this.$_ls_data_keys.forEach(key => {
        const val = hash[key]
        if (val != null) {
          this[key] = val
        } else {
          this[key] = this.ls_data[key] // 初期値設定
        }
      })
    },

    $_ls_reset() {
      this.lst_delete(this.ls_key)
      this.$_ls_load()
    },
  },

  computed: {
    ls_key() {
      return this.$options.name || alert("ls_key is not implemented")
    },

    ls_data() {
      alert("ls_data is not implemented")
    },

    $_ls_data_keys() {
      return Object.keys(this.ls_data)
    },

    $_ls_watch_values() {
      return this.$_ls_data_keys.map(e => this[e])
    },

    // ハッシュ型にした保存するデータ
    $_ls_hash() {
      return this.$_ls_data_keys.reduce((a, e) => ({...a, [e]: this[e]}), {})
    },
  },
}
