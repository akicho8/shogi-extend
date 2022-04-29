import _ from "lodash"
const VS_USERS_ARRAY_SIZE_MAX = 30

export const app_vs_user = {
  methods: {
    // 入力値 str を正規化して再検索
    vs_user_research_handle(str) {
      const av = this.str_to_tags(str)
      if (this.present_p(av)) {
        str = "vs:" + av.join(",")
      } else {
        str = null
      }
      const new_query = _.compact([this.xi.current_swars_user_key, str]).join(" ")
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
