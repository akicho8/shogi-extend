import _ from "lodash"
import VsUserModal from "./VsUserModal.vue"

const VS_USERS_ARRAY_SIZE_MAX = 30

export const app_vs_user = {
  methods: {
    // 対戦相手ID入力するモーダルを開く
    vs_user_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: VsUserModal,
        props: { base: this.base },
      })
    },

    // 入力値 str を正規化して再検索
    vs_user_research_handle(str) {
      const av = this.str_to_tags(str)
      if (this.present_p(av)) {
        str = "vs:" + av.join(",")
      } else {
        str = null
      }
      const new_query = _.compact([this.config.current_swars_user_key, str]).join(" ")
      this.remote_notify({subject: "相手で絞る", body: new_query})
      this.$router.push({name: "swars-search", query: {query: new_query}})
    },

    // 入力値 str を正規化して補完リストとして localStorage に入れておく
    vs_user_keys_remember(str) {
      let av = this.str_to_tags(str)
      if (this.present_p(av)) {
        av = [...av, ...this.remember_vs_user_keys]
        av = _.uniq(av)
        av = _.take(av, VS_USERS_ARRAY_SIZE_MAX)
        this.remember_vs_user_keys = av
      }
    },
  },
}
