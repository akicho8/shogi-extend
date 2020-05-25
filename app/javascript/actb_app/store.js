import Vuex from "vuex"

export const store = () => new Vuex.Store({
  state: {
    gvar1: "(gvar1)",
    app: null,
  },

  // 便利参照メソッドを書く
  getters: {
    current_gvar1(state) {
      return state.gvar1
    },
    current_gvar1_variant(state, getters) {
      return `(${getters.current_gvar1})`
    },
  },

  // 同期更新
  mutations: {
    // this.$store.commit("gvar1_set", "foo")
    gvar1_set(state, payload) {
      state.gvar1 = payload
    },
  },

  // 非同期でもいい場合。意味わからん
  actions: {
    // this.$store.dispatch('gvar1_set', 'foo')
    gvar1_set2(context, payload) {
      context.commit('gvar1_set', payload)
    },
  },
})
