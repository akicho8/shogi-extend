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
  // this.$store.dispatch("current_user_fetch")
  async current_user_fetch({commit}) {
    // http://localhost:3000/api/session/current_user_fetch.json
    return this.$axios.$get(`/api/session/current_user_fetch.json`).then(e => {
      commit('current_user_set', e)
    })
  },
}
