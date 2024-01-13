import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import RoomSetupModal from "./RoomSetupModal.vue"
import { HandleNameValidator } from "@/components/models/handle_name/handle_name_validator.js"

export const mod_room_setup_modal = {
  data() {
    return {
      new_room_key: null,
      new_user_name: null,
      rsm_instance: null,
    }
  },
  mounted() {
  },
  beforeDestroy() {
    this.rsm_close()
  },
  methods: {
    rsm_toggle_handle() {
      if (this.rsm_instance == null) {
        this.sidebar_p = false
        this.$sound.play_click()
        this.rsm_open()
        return true
      }
    },

    rsm_open_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.rsm_open()
    },

    rsm_close_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.rsm_close()
    },

    rsm_open() {
      this.rsm_close()

      this.new_room_key = this.room_key
      this.new_user_name = this.user_name

      this.rsm_instance = this.modal_card_open({
        component: RoomSetupModal,
        onCancel: () => {
          this.$sound.play_click()
          this.rsm_close()
        },
      })
    },

    rsm_close() {
      if (this.rsm_instance) {
        this.rsm_instance.close()
        this.rsm_instance = null
      }
    },

    rsm_leave_handle() {
      this.$sound.play_click()
      if (this.ac_room) {
        // this.toast_ok("退室しました")
        this.room_destroy()
      } else {
        this.toast_warn("今は部屋の外です")
      }
    },

    rsm_entry_handle() {
      this.$sound.play_click()

      this.new_room_key = _.trim(this.new_room_key)
      this.new_user_name = _.trim(this.new_user_name)

      if (Gs.blank_p(this.new_room_key)) {
        this.toast_warn("合言葉を入力してください")
        return
      }

      if (this.handle_name_invalid_then_toast_warn(this.new_user_name)) {
        return
      }

      this.room_create_by(this.new_room_key, this.new_user_name)

      if (this.auto_close_p) {
        this.rsm_close_handle()
      }
    },
  },
  computed: {
  },
}
