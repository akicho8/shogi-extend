import QueryString from "query-string"
import SbDashboard3Modal from "./SbDashboard3Modal.vue"

export const mod_dashboard3 = {
  beforeDestroy() {
    this.general_dashboard3_modal_close()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    general_dashboard3_modal_open_handle() {
      if (!this.general_dashboard3_modal_instance) {
        this.sfx_click()
        this.general_dashboard3_modal_open()
      }
    },

    general_dashboard3_modal_close_handle() {
      if (this.general_dashboard3_modal_instance) {
        this.sfx_click()
        this.general_dashboard3_modal_close()
      }
    },

    ////////////////////////////////////////

    general_dashboard3_modal_open() {
      if (!this.general_dashboard3_modal_instance) {
        this.general_dashboard3_modal_instance = this.modal_card_open({
          component: SbDashboard3Modal,
          onCancel: () => {
            this.sfx_click()
            this.general_dashboard3_modal_close()
          },
        })
      }
    },

    general_dashboard3_modal_close() {
      if (this.general_dashboard3_modal_instance) {
        this.general_dashboard3_modal_instance.close()
        this.general_dashboard3_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },

  // computed: {
  //   dashboard3_url() {
  //     return QueryString.stringifyUrl({
  //       url: `/share-board/dashboard3`,
  //       query: {room_key: this.room_key},
  //     })
  //   },
  // },
}
