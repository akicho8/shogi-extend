// https://qiita.com/y-miine/items/028c73aa3f87e983ed4c

export const state = () => ({
  g_current_user: null,
  g_user_counter: 0,
})

export const mutations = {
  m_auth_user_set(state, payload) {
    state.g_current_user = payload
  },
  m_auth_user_logout(state) {
    state.g_current_user = null
  },
  m_g_user_counter_add(state, payload) {
    state.g_user_counter += payload
  },
}

export const actions = {
  // this.$store.dispatch("a_auth_user_fetch")
  async a_auth_user_fetch({commit}) {
    // http://localhost:3000/api/session/auth_user_fetch.json
    return this.$axios.$get("/api/session/auth_user_fetch.json").then(e => {
      commit("m_auth_user_set", e)
    })
  },
  // this.$store.dispatch("auth_user_logout")
  async a_auth_user_logout({commit}) {
    // curl -d _method=delete http://localhost:3000/api/session/auth_user_logout.json
    return this.$axios.$delete("/api/session/auth_user_logout.json").then(e => {
      commit("m_auth_user_logout")
      // FIXME: 結果を表示したいけどどうやって notice_collector_run を呼ぶ？ → というかサーバー側で呼ばれているので無理なのか？？？
    })
  },
}
