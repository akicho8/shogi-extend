// index.js を置くことで vuex が有効になるっぽい

export const state = () => ({
  g_counter: 0,
  g_axios_loading: false,
})

// ↓ここに定義したらさらに ...mapGetters(["g_loading_p"]) が必要。
export const getters = {
  g_loading_p: state => state.g_axios_loading
}

export const mutations = {
  increment(state) {
    state.g_counter += 1
  },
  g_axios_loading_set(state, status) {
    state.g_axios_loading = status
  },
}

// https://ja.nuxtjs.org/guide/vuex-store/#nuxtserverinit-%E3%82%A2%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3
// > Vuex ストアの モジュール モードを使っている場合はなら、プライマリモジュール（store/index.js）のみ
// このアクションを受け取ることができます。
//
// https://tech.glatchdesign.com/nuxtjs-vuex-module-mode
export const actions = {
  async nuxtServerInit ({ commit, dispatch }, { req }) {
    await dispatch("user/a_auth_user_fetch")

    // if (req.session && req.session.current_user) {
    //   commit('m_auth_user_set', req.session.current_user)
    // }

    // USER_AGENT がとれる
    // console.log("user-agent")
    // console.log(req.headers['user-agent'])
  },
}
