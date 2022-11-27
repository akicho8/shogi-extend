import RoomCodeCopyModal from "./RoomCodeCopyModal.vue"

export const app_room_code_copy = {
  methods: {
    room_code_copy_modal_handle() {
      this.modal_card_open({
        component: RoomCodeCopyModal,
      })
    },
  },
}
