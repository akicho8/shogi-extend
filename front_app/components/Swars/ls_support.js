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
//       ls_storage_key() {
//         return "my_app" // localStorage のキー ← デフォルトでは this.$options.name なのでそのままでもよい
//       },
//
//       ls_default() {
//         return {
//           my_var1: false, // 初期値
//         }
//       },
//     },
//   }

import { MyLocalStorage } from "@/components/models/MyLocalStorage.js"

export default {
  beforeDestroy() {
    this.ls_destroy()
  },

  methods: {
    ls_setup() {
      if (!this.$ls_unwatch) {
        this.ls_load()
        // 変数がハッシュかもしれないので deep: true にしておく
        this.$ls_unwatch = this.$watch(() => this.ls_attributes, () => this.ls_save(), {deep: true})
      }
    },

    // private

    ls_destroy() {
      if (this.$ls_unwatch) {
        this.$ls_unwatch()
        this.$ls_unwatch = null
      }
    },

    ls_save() {
      MyLocalStorage.set(this.ls_storage_key, this.ls_attributes)
    },

    ls_load() {
      this.ls_restore(MyLocalStorage.get(this.ls_storage_key))
    },

    ls_restore(hash) {
      if (!hash) {
        hash = {}
      }
      this.ls_keys.forEach(key => {
        if (key in hash) {
          this[key] = hash[key]
        } else {
          this[key] = this.ls_default[key] // 初期値設定
        }
      })
    },

    ls_reset() {
      MyLocalStorage.remove(this.ls_storage_key)
      this.ls_load()
    },
  },

  computed: {
    ls_storage_key() {
      return this.$options.name || alert("ls_storage_key is not implemented")
    },

    // 初期値を設定することで使われているキーがわかる
    ls_default() {
      alert("ls_default is not implemented")
    },

    // private

    ls_keys() {
      return Object.keys(this.ls_default)
    },

    ls_values() {
      return this.ls_keys.map(e => this[e])
    },

    ls_attributes() {
      return this.ls_keys.reduce((a, e) => ({...a, [e]: this[e]}), {})
    },
  },
}
