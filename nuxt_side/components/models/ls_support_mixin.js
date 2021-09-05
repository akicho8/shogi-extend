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

export const ls_support_mixin = {
  beforeDestroy() {
    this.ls_destroy()
  },

  methods: {
    ls_setup() {

      // server → client の順で2回呼ばれるので2回目のときだけ変数を復帰する(重要)

      if (process.client) {
        this.clog("[ls_setup]")
        if (!this.$ls_unwatch) {
          this.ls_load()
          // 変数がハッシュかもしれないので deep: true にしておく
          this.clog("[ls_unwatch] ON")
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
            debugger
            throw new Error(`[${this.ls_storage_key}] ${k} が null のまま localStorage に保存しようとしている`)
          }
        })
      }
      MyLocalStorage.set(this.ls_storage_key, this.ls_attributes)
    },

    ls_load() {
      this.clog(`[ls_load] from ${this.ls_storage_key}`)
      this.ls_restore(MyLocalStorage.get(this.ls_storage_key))
    },

    ls_restore(hash) {
      this.ls_keys.forEach(key => {

        let exec = true

        if (this.ls_config.SKIP_IF_PRESENT) {
          const v = this.$data[key]
          if (v != null) {
            console.log(`[ls_restore] ${key} は復帰する前に値があるためスキップ : ${v}`)
            exec = false
          }
        }

        // if (this.ls_config.SKIP_IF_QUERY) {
        //   const v = this.$route.query[key]
        //   if (v != null) {
        //     console.log(`[ls_restore] ${key} は復帰する前に同じキーのクエリがあるためスキップ : ${v}`)
        //     exec = false
        //   }
        // }

        if (exec) {
          this.ls_restore_one_from_hash(key, hash)
        }
      })
    },

    ls_restore_one_from_hash(key, hash) {
      hash ??= {}
      const d = this.ls_default[key]    // => {a: 1, b: 2} (default value)
      let v = null
      if ((key in hash) && (hash[key] != null)) { // 保存している値が null のときは初期値に戻す
        const s = hash[key]             // => {a: 0,     } (stored value)
        if (this.ls_config.HASH_MERGE_P && _.isPlainObject(d) && _.isPlainObject(s)) {
          v = {..._.cloneDeep(d), ...s} // => {a: 0, b: 2} 初期値に対してマージ
          this.clog(`[ls_restore] ${key} <-- ${JSON.stringify(v)} (hash)`)
        } else {
          this.clog(`[ls_restore] ${key} <-- ${JSON.stringify(s)} (direct)`)
          v = s                         // マージできないのでストアされたものをそのまま使う
        }
      } else {
        this.clog(`[ls_restore] ${key} <-- ${JSON.stringify(d)} (default)`)
        v = d
      }

      if (key in this.$data) {
      } else {
        alert(`data() に ${key} を null で定義してください`)
      }

      this.$data[key] = v
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

    ls_config() {
      return {
        HASH_MERGE_P: true,    // ハッシュは復元するときに初期値に対してマージするか？
        SKIP_IF_PRESENT: true, // 値があるものは上書きしない
        // SKIP_IF_QUERY: false,  // クエリに同じものがある場合は復帰しない
        ...this.ls_user_config,
      }
    },

    ls_user_config() {
      return {}
    },
  },
}
