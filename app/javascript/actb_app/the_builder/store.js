// import Vuex from "vuex"
// import builder from "the_builder/store.js"

export const builder = {
  namespaced: true,
  state() {
    return {
      gvar2: null,
      question: null,
    }
  },
  getters: {
    current_gvar2(state) {
      return state.gvar2
    },
    current_gvar2_variant(state, getters) {
      return `(${getters.current_gvar2})`
    },
  },

  //
  // // 同期更新
  // mutations: {
  //   // this.$store.commit("gvar2_set", "foo")
  //   gvar2_set(state, payload) {
  //     state.gvar2 = payload
  //   },
  // },
  //
  // // 非同期でもいい場合。意味わからん
  // actions: {
  //   // this.$store.dispatch('gvar2_set', 'foo')
  //   gvar2_set2(context, payload) {
  //     context.commit('gvar2_set', payload)
  //   },
  // },
}
