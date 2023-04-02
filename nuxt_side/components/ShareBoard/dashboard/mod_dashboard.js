const QueryString = require("query-string")
import SbDashboardModal from "./SbDashboardModal.vue"

export const mod_dashboard = {
  methods: {
    general_dashboard_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: SbDashboardModal,
        props: { base: this.base },
      })
    },
    dashboard_link_click_handle() {
    },
  },

  computed: {
    dashboard_url() {
      return QueryString.stringifyUrl({
        url: `/share-board/${this.room_code}/dashboard`,
        query: {},
      })
    },
  },
}
