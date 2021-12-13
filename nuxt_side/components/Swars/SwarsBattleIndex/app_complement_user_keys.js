import _ from "lodash"
import { ComplementUserKeysPrependInfo } from "./models/complement_user_keys_prepend_info.js"

export const app_complement_user_keys = {
  methods: {
    // JavaScript 側の this.complement_user_keys が空ならRails側で管理していた remember_swars_user_keys をコピーする
    // TODO: この処理は数ヶ月後、Rails 側の remember_swars_user_keys を作る部分と合わせて捨てる
    rails_session_side_copy_to_user_keys_if_blank() {
      if (this.blank_p(this.complement_user_keys)) {
        const old = this.xi.remember_swars_user_keys
        if (this.present_p(old)) {
          this.complement_user_keys = [...old]
        }
      }
    },

    // $fetch 直後に this.xi.current_swars_user_key が有効なら履歴に取り込む
    // this.xi.current_swars_user_key の
    user_keys_update_by_query() {
      if (this.blank_p(this.xi.current_swars_user_key)) {
        // 指定のウォーズIDは存在しません状態なのでクエリがあったとしても履歴に取り込んではいけない
        return
      }

      let str = this.complement_user_keys_prepend_info.str_fetch(this)
      str = this.str_squish(str)
      if (this.present_p(str)) {
        let av = [str, ...this.complement_user_keys]
        av = _.uniq(av)
        av = _.take(av, this.complement_user_keys_size_max)
        this.complement_user_keys = av
      }
    },
  },

  computed: {
    ComplementUserKeysPrependInfo()     { return ComplementUserKeysPrependInfo },
    complement_user_keys_prepend_info() { return this.ComplementUserKeysPrependInfo.fetch(this.complement_user_keys_prepend_key) },

    // b-autocomplete の data に渡す値
    search_input_complement_list() {
      if (this.complement_user_keys) {
        return this.complement_user_keys.filter(option => {
          const a = option.toString().toLowerCase()
          const b = (this.query || "").toLowerCase()
          return a.indexOf(b) >= 0
        })
      }
    },
  },
}
