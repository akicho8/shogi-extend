// 超簡単に変数を永続化するテンプレートメソッドパターン
//
// 使う側で書くこと
//
//   import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"
//
//   {
//     mixins: [ls_support_mixin],
//
//     data() {
//       return {
//         my_var1: null, // ここの値は意味ないので null でよい
//       }
//     },
//
//     created() {
//       this.ls_setup() // fetch() のなかで呼ぶなど臨機応変に。
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

import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import _ from "lodash"

const HASH_MERGE_P = true // ハッシュは復元するときに初期値に対してマージするか？

export const ls_support_mixin = {
  beforeDestroy() {
    this.ls_destroy()
  },

  methods: {
    ls_setup() {
      // server → client の順で2回呼ばれるので2回目のときだけ変数を復帰する(重要)

      this.clog("ls_setup process.client", process.client)
      this.clog("ls_setup process.server", process.server)

      if (process.client) {
        if (!this.$ls_unwatch) {
          this.ls_load()
          // 変数がハッシュかもしれないので deep: true にしておく
          this.$ls_unwatch = this.$watch(() => this.ls_attributes, () => this.ls_save(), {deep: true})
        }
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
      if (this.development_p || true) {
        _.each(this.ls_attributes, (v, k) => {
          if (v == null) {
            throw new Error(`[${this.ls_storage_key}] ${k} に null を設定している`)
          }
        })
      }
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
        const d = this.ls_default[key]    // => {a: 1, b: 2} (default value)
        let v = null
        if ((key in hash) && (hash[key] != null)) { // 保存している値が null のときは初期値に戻す
          const s = hash[key]             // => {a: 0,     } (stored value)
          if (HASH_MERGE_P && _.isPlainObject(d) && _.isPlainObject(s)) {
            v = {..._.cloneDeep(d), ...s} // => {a: 0, b: 2} 初期値に対してマージ
            this.clog("ls_restore", v)
          } else {
            v = s                         // マージできないのでストアされたものをそのまま使う
          }
        } else {
          v = d
        }
        this[key] = v
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
