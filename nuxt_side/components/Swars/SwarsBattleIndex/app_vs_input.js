import _ from "lodash"
import VsInputModal from "./VsInputModal.vue"

const VS_INPUT_REMEMBER_MAX = 30

export const app_vs_input = {
  methods: {
    // 対戦相手ID入力するモーダルを開く
    vs_input_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: VsInputModal,
        props: { base: this.base },
      })
    },

    // 入力値 str を正規化して再検索
    vs_filter_run_handle(str) {
      const keywords = this.str_to_keywords(str)
      if (keywords.length >= 1) {
        str = "vs:" + keywords.join(",")
      } else {
        str = null
      }
      const new_query = _.compact([this.config.current_swars_user_key, str]).join(" ")
      this.$router.push({name: "swars-search", query: {query: new_query}})
    },

    // 入力値 str を正規化して補完リストとして localStorage に入れておく
    vs_user_keys_remember(str) {
      const keywords = this.str_to_keywords(str)
      if (keywords.length >= 1) {
        this.remember_vs_user_keys = _.take(_.uniq([...keywords, ...this.remember_vs_user_keys]), VS_INPUT_REMEMBER_MAX)
      }
    },
  },
}
