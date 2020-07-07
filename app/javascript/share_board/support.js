import Vuex from "vuex"

export const support = {
  computed: {
    ...Vuex.mapState([
      "app",
    ]),
  },
}
