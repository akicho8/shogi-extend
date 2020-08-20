import { support as root_support } from "../support.js"
import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

export const support = {
  mixins: [
    root_support,
  ],
  computed: {
    ...mapGetters("builder", [
      "current_gvar2",
      "current_question",
    ]),
    ...mapState("builder", [
      "question",
    ]),
  },
}
