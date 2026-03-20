import RoomUrlCopyModal from "./RoomUrlCopyModal.vue"

export const mod_room_url_copy = {
  beforeDestroy() {
    this.room_url_copy_modal_close()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    room_url_copy_modal_open_handle() {
      if (!this.room_url_copy_modal_instance) {
        this.sfx_click()
        this.room_url_copy_modal_open()
      }
    },

    room_url_copy_modal_close_handle() {
      if (this.room_url_copy_modal_instance) {
        this.sfx_click()
        this.room_url_copy_modal_close()
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_url_copy_modal_open() {
      if (!this.room_url_copy_modal_instance) {
        this.room_url_copy_modal_instance = this.modal_card_open({
          component: RoomUrlCopyModal,
          onCancel: () => {
            this.sfx_click()
            this.room_url_copy_modal_close()
          },
        })
      }
    },

    room_url_copy_modal_close() {
      if (this.room_url_copy_modal_instance) {
        this.room_url_copy_modal_instance.close()
        this.room_url_copy_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
