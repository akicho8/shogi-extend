// 使い方
//
//   // this.ParamInfo を参照できるようにしておく
//
//   import { params_controller } from "@/components/params_controller.js"
//
//   export const app_storage = {
//     mixins: [params_controller],
//   }
//

import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const params_controller = {
  mixins: [
    ls_support_mixin,
  ],
  beforeMount() {
    this.__assert__(this.ParamInfo, "this.ParamInfo")
    this.ls_setup()                                  // 1. 変数(すべてnull)に必要なぶんだけ localStorage から復帰する
    this.pc_data_set_by_query_or_default()           // 2. query があれば「上書き」する。また null の変数には初期値を設定する
    this.pc_restore_default_value_if_invalid_value() // 3. 不正な値を初期値に戻す
    this.pc_mounted()
  },
  methods: {
    pc_mounted() {
      // 後処理
    },
    pc_data_set_by_query_or_default() {
      this.ParamInfo.values.forEach(e => {
        let v = this.$route.query[e.key]
        if (this.present_p(v)) {
          if (e.type === "integer") {
            v = Math.trunc(Number(v))
          } else if (e.type === "float") {
            v = Number(v)
          }
          this.$data[e.key] = v
        } else {
          if (this.$data[e.key] == null) {
            this.$data[e.key] = e.default
          }
        }
      })
    },
    pc_data_reset_handle() {
      this.sound_play("click")
      this.sidebar_p = false
      this.pc_data_reset()
    },
    pc_data_reset() {
      this.ParamInfo.values.forEach(e => {
        if (e.default != null) {
          this.$data[e.key] = e.default
        }
      })
    },
    // 無効な値なら初期値に戻す
    // これをしないと localStorage に保存してある過去の値で復帰しようとしてアプリが起動しなくなる
    pc_restore_default_value_if_invalid_value() {
      this.ParamInfo.values.forEach(e => {
        const value = this.$data[e.key]
        if (e.relation) {
          if (this[e.relation].lookup(value)) {
            this.clog(`[設定値][OK] this.${e.key} は ${this.short_inspect(value)} のままで良い`)
          } else {
            this.$data[e.key] = e.default
            this.clog(`[設定値][NG] this.${e.key} の ${this.short_inspect(value)} を ${this.short_inspect(e.default)} に変更`)
          }
        }
      })
    },
  },
  computed: {
    pc_ls_default() {
      return this.ParamInfo.values.filter(e => e.permanent).reduce((a, e, i) => ({...a, [e.key]: e.default}), {})
    },
    ls_default() {
      return this.pc_ls_default
    },
  },
}
