import RoomUrlCopyModal from "./RoomUrlCopyModal.vue"

export const mod_room_url_copy = {
  methods: {
    room_url_copy_modal_handle() {
      this.modal_card_open({
        component: RoomUrlCopyModal,
      })
    },
  },
}
