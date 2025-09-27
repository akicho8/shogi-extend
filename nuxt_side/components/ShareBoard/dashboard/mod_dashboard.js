import QueryString from "query-string"
import SbDashboardModal from "./SbDashboardModal.vue"

export const mod_dashboard = {
  methods: {
    general_dashboard_modal_handle() {
      this.sidebar_p = false
      this.sfx_click()
      this.modal_card_open({
        component: SbDashboardModal,
      })
    },
  },

  computed: {
    dashboard_url() {
      return QueryString.stringifyUrl({
        url: `/share-board/dashboard`,
        query: {room_key: this.room_key},
      })
    },
  },
}
