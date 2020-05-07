import Vuex from "vuex"

export default () => new Vuex.Store({
  state: {
    app_var1: "foo",
  },

  // // 便利参照メソッドを書く
  getters: {
    current_app_var1(state) {
      return state.app_var1
    },
    // fooName (state, getters) {
    //   return getters.currentFooInfo.name
    // },
  },

  // // 更新内容を書く
  // mutations: {
  //   // this.$store.commit("fooKeySet", "alice")
  //   fooKeySet (state, payload) {
  //     state.fooKey = payload
  //   },
  // },
  //
  // // mutations を呼び出すメソッドを書く(これを置く理由はわからない)
  // actions: {
  //   // this.$store.dispatch('fooKeySet', 'bob')
  //   fooKeySet (context, payload) {
  //     context.commit('fooKeySet', payload)
  //   },
  // },
})
