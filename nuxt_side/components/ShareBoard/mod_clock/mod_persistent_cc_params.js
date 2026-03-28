// 時計のパラメータを永続化
//
// ▼URLに指定する値
// persistent_cc_params=[{"initial_main_min":7,"initial_read_sec":0,"initial_extra_min":0,"every_plus":0}]
//
// ▼指定したもの
// http://localhost:4000/share-board?persistent_cc_params=%5B%7B%22initial_main_min%22%3A7,%22initial_read_sec%22%3A0,%22initial_extra_sec%22%3A0,%22every_plus%22%3A0%7D%5D

import _ from "lodash"

export const mod_persistent_cc_params = {
  methods: {
    // localStorage から現在のパラメータにコピー
    cc_params_load() {
      this.cc_params = _.cloneDeep(this.persistent_cc_params)
      this.cc_params_normalize()
      this.cc_params_debug("LOAD", this.cc_params)
    },

    // 属性名を変えても localStorage から読み出される属性は以前のままのためデフォルト値で上書きする
    // また新しい属性名だけを残す
    cc_params_normalize() {
      this.cc_params = this.cc_params.map(e => {
        const hv = {}
        _.forIn(this.CcRuleInfo.default_cc_params_one, (default_value, attr) => {
          hv[attr] = e[attr] ?? default_value
        })
        return hv
      })
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
    cc_params_convert_to_array_of_hash() {
      if (!_.isArray(this.persistent_cc_params)) {
        this.persistent_cc_params = _.cloneDeep([this.persistent_cc_params])
      }
    },
  },
}
