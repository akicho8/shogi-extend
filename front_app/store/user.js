// https://qiita.com/y-miine/items/028c73aa3f87e983ed4c

export const state = () => ({
  g_current_user: null,
  user_counter: 0,
})

export const mutations = {
  current_user_set(state, payload) {
    state.g_current_user = payload
  },
  current_user_clear(state) {
    state.g_current_user = null
  },
  user_counter_add(state, payload) {
    state.user_counter += payload
  },
}

export const actions = {
  // this.$store.dispatch("auth_user_fetch")
  async auth_user_fetch({commit}) {
    // http://localhost:3000/api/session/auth_user_fetch.json
    return this.$axios.$get(`/api/session/auth_user_fetch.json`).then(e => {
      commit('current_user_set', e)
    })
  },
  // this.$store.dispatch("current_user_clear")
  async current_user_clear({commit}) {
    // curl -d _method=delete http://localhost:3000/api/session/auth_user_logout.json
    return this.$axios.$delete(`/api/session/auth_user_logout.json`).then(e => {
      commit('current_user_clear')
      // FIXME: 結果を表示したいけどどうやって notice_collector_run を呼ぶ？ → というかサーバー側で呼ばれているので無理なのか？？？
    })
  },
}
