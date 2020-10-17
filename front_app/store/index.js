// index.js を置くことで vuex が有効になるっぽい

export const state = () => ({
  g_counter: 0
})

export const mutations = {
  increment(state) {
    state.g_counter += 1
  }
}

// https://ja.nuxtjs.org/guide/vuex-store/#nuxtserverinit-%E3%82%A2%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3
// > Vuex ストアの モジュール モードを使っている場合はなら、プライマリモジュール（store/index.js）のみ
// このアクションを受け取ることができます。
//
// https://tech.glatchdesign.com/nuxtjs-vuex-module-mode
export const actions = {
  async nuxtServerInit ({ commit, dispatch }, { req }) {
    await dispatch("user/auth_user_fetch")
    // if (req.session && req.session.current_user) {
    //   commit('current_user_set', req.session.current_user)
    // }
  },
}
