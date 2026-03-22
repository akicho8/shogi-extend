import { GX } from "@/components/models/gx.js"
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
        this.sfx_play("se_notification")
        this.sb_talk("部屋のURLをコピーしますか？")
        this.modal_card_open2("room_url_copy_modal_instance", {
          component: RoomUrlCopyModal,
          events: {
            close: () => this.room_url_copy_modal_close(),
          },
        })
      }
    },

    room_url_copy_modal_close() {
      if (this.room_url_copy_modal_instance) {
        this.modal_card_close2("room_url_copy_modal_instance")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_url_copy_handle() {
      if (this.room_required_warn_message()) { return }

      GX.assert(this.cable_p)
      GX.assert_present(this.room_key)

      this.sfx_click()
      this.clipboard_copy(this.room_url, {success_message: "部屋のURLをコピーしました"})
      this.room_url_copy_modal_close()
    },
  },
}
