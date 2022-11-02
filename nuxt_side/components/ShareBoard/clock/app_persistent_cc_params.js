// 時計のパラメータを永続化
//
// ▼URLに指定する値
// persistent_cc_params=[{"initial_main_min":7,"initial_read_sec":0,"initial_extra_sec":0,"every_plus":0}]
//
// ▼指定したもの
// http://localhost:4000/share-board?persistent_cc_params=%5B%7B%22initial_main_min%22%3A7,%22initial_read_sec%22%3A0,%22initial_extra_sec%22%3A0,%22every_plus%22%3A0%7D%5D

import _ from "lodash"

export const app_persistent_cc_params = {
  methods: {
    // localStorage から現在のパラメータにコピー
    cc_params_load() {
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
    persistent_cc_params_array_wrap() {
      if (!_.isArray(this.persistent_cc_params)) {
        this.persistent_cc_params = _.cloneDeep([this.persistent_cc_params])
      }
    },
  },
}
