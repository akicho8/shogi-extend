import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"
import _ from "lodash"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  beforeMount() {
    this.ls_setup()                     // 1. 変数(すべてnull)に必要なぶんだけ localStorage から復帰する
    this.data_set_by_query_or_default() // 2. query があれば上書きする。また null の変数には初期値を設定する
    this.form_setup()                   // 3. 後処理
  },
  methods: {
    data_set_by_query_or_default() {
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
    data_reset_handle() {
      this.sound_play("click")
      this.sidebar_p = false
      this.data_reset()
    },
    data_reset() {
      this.ParamInfo.values.forEach(e => {
        if (e.default != null) {
          this.$data[e.key] = e.default
        }
      })
    },
  },
  computed: {
    ls_storage_key() {
      return "movie-factory-v1"
    },
    ls_default() {
      return this.ParamInfo.values.filter(e => e.permanent).reduce((a, e, i) => ({...a, [e.key]: e.default}), {})
    },
  },
}
