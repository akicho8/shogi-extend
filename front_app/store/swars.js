export const state = () => ({
  g_var1: [],
})

export const mutations = {
  m_remember_swars_user_keys_set(state, payload) {
    state.g_var1 = payload
  },
}

export const actions = {
}
