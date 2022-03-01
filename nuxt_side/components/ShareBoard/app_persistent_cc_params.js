// 時計のパラメータを永続化

const COMPATIBILITY_WITH_OLD_VERSION = true // 古い仕様を考慮してハッシュからハッシュの配列に変換する

import _ from "lodash"

export const app_persistent_cc_params = {
  methods: {
    // localStorage から現在のパラメータにコピー
    cc_params_load() {
      // this.persistent_cc_params = {
      //   "initial_main_min": 7,
      //   "initial_read_sec": 0,
      //   "initial_extra_sec": 0,
      //   "every_plus": 0,
      // }
      this.cc_params_update_to_array_of_hash()
      this.cc_params = _.cloneDeep(this.persistent_cc_params)
      this.cc_params_debug("LOAD", this.cc_params)
    },

    // 現在のパラメータを localStorage 保存
    cc_params_save() {
      this.persistent_cc_params = _.cloneDeep(this.cc_params)
      this.cc_params_debug("SAVE", this.persistent_cc_params)
    },

    // 初期値(localStorage) をリセット
    cc_params_reset() {
      this.persistent_cc_params = _.cloneDeep(this.CcRuleInfo.default_cc_params)
      this.cc_params_debug("RESET", this.persistent_cc_params)
    },

    // 以前は一つのハッシュだったので配列でなければハッシュの配列に変更する
    cc_params_update_to_array_of_hash() {
      if (COMPATIBILITY_WITH_OLD_VERSION) {
        if (!_.isArray(this.persistent_cc_params)) {
          this.persistent_cc_params = _.cloneDeep([this.persistent_cc_params])
        }
      }
    },
  },
}
