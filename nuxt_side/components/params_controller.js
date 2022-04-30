// 使い方
//
// ▼this.ParamInfo を参照できるようにしておく
//
//   import { ParamInfo         } from "./models/param_info.js"
//   computed: {
//      ParamInfo() { return ParamInfo },
//   },
//
// ▼本体
//
//   import { params_controller } from "@/components/params_controller.js"
//
//   export const app_storage = {
//     mixins: [params_controller],
//   }
//
// ▼初回に @input="xxx_handle" などが反応してしまうのを回避するには？
//
//   xxx_handle() {
//     if (this.pc_standby_ok >= 1) {
//       this.sound_play_click()
//     }
//   }
//
import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const params_controller = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      pc_standby_ok: 0,
    }
  },
  beforeMount() {
    this.clog(`[params_controller] begin`)
    this.__assert__(this.ParamInfo, "this.ParamInfo")
    this.ls_setup()                                  // 1. 変数(すべてnull)に必要なぶんだけ localStorage から復帰する
    this.pc_data_set_by_query_or_default()           // 2. query があれば「上書き」する。また null の変数には初期値を設定する
    this.pc_restore_default_value_if_invalid_value() // 3. 不正な値を初期値に戻す
    this.pc_mounted()
    this.clog(`pc_standby_ok: ${this.pc_standby_ok}`)
    this.$nextTick(() => {
      this.pc_standby_ok += 1
      this.clog(`pc_standby_ok: ${this.pc_standby_ok}`)
    })
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
          } else if (e.type === "array") {
            v = this.str_to_words(v)
          } else if (e.type === "boolean") {
            v = this.str_to_boolean(v)
          } else {
            // string
          }
          this.clog(`this.$data["${e.key}"] = ${JSON.stringify(v)} (from query)`)
          this.$data[e.key] = v
        } else {
          if (this.$data[e.key] == null) {
            const v = e.default_for(this)
            this.clog(`this.$data["${e.key}"] = ${JSON.stringify(v)} (from default)`)
            this.$data[e.key] = v
          }
        }
      })
    },
    pc_data_reset_handle(options = {}) {
      this.sound_play_click()
      if ("sidebar_p" in this) {
        this.sidebar_p = false
      }
      this.pc_data_reset(options)
    },

    pc_data_reset(options = {}) {
      options = {
        only: null,
        except: null,
        ...options,
      }
      let records = this.ParamInfo.values
      if (options.only) {
        records = records.filter(e => options.only.includes(e.key))
      } else if (options.except) {
        records = records.filter(e => !options.except.includes(e.key))
      }
      this.pc_data_reset_records(records)
    },

    pc_data_reset_records(records) {
      records.forEach(e => {
        const v = e.default_for(this)
        if (v != null) {
          this.clog(`this.$data["${e.key}"] = ${JSON.stringify(v)} (from default)`)
          this.$data[e.key] = v
        }
      })
    },

    // resetable: true の指定があるものだけリセットする
    pc_data_reset_resetable_only() {
      const records = this.ParamInfo.values.filter(e => e.resetable)
      this.pc_data_reset_records(records)
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
            this.$data[e.key] = e.default_for(this)
            this.clog(`[設定値][NG] this.${e.key} の ${this.short_inspect(value)} を ${this.short_inspect(e.default_for(this))} に変更`)
          }
        }
      })
    },

    // paramsの値が空か初期値と一致すれば削除する
    pc_url_params_clean(params) {
      const hv = {...params}
      this.ParamInfo.values.forEach(e => {
        const v = hv[e.key]
        if (this.blank_p(v) || v === e.default_for(this)) {
          delete hv[e.key]
        }
      })
      return hv
    },
  },
  computed: {
    pc_ls_default() {
      return this.ParamInfo.values.filter(e => e.permanent).reduce((a, e, i) => ({...a, [e.key]: e.default_for(this)}), {})
    },
    ls_default() {
      return this.pc_ls_default
    },
    // ls_attributes なら ls_default のキーが元になる
    pc_attributes() { return this.ParamInfo.values.reduce((a, e) => ({...a, [e.key]: this.$data[e.key]}), {}) },
  },
}
