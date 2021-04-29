import _ from "lodash"
import dayjs from "dayjs"
import VsInputModal from "./VsInputModal.vue"

export const app_vs_input = {
  methods: {
    vs_input_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: VsInputModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },

    vs_input_filter_run_handle(str) {
      const keywords = this.str_to_keywords(str)
      if (keywords.length >= 1) {
        str = "vs:" + keywords.join(",")
      } else {
        str = null
      }
      const new_query = _.compact([this.config.current_swars_user_key, str]).join(" ")
      this.$router.push({name: "swars-search", query: {query: new_query}})
    },
  },
}
