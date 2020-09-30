import Vuex from "vuex"

export const store = () => new Vuex.Store({
  state: {
    app: null,
    external_app_setup: null,
  },
})
