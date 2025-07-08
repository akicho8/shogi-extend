import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import RoomSetupModal from "./RoomSetupModal.vue"
import { RoomKeyValidator } from "../models/room_key_validator.js"
import { HandleNameValidator } from "@/components/models/handle_name/handle_name_validator.js"
import { HandleNameNormalizer } from "@/components/models/handle_name/handle_name_normalizer.js"

export const mod_room_setup_modal = {
  data() {
    return {
      new_room_key: null,       // 入力中の合言葉
      new_user_name: null,      // 入力中のハンドルネーム
      rsm_instance: null,
    }
  },
  beforeDestroy() {
    this.rsm_close()
  },
  methods: {
    rsm_open_shortcut_handle() {
      if (this.rsm_instance) {
        return
      }
      this.rsm_open_handle()
      return true
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
        this.room_destroy()
      } else {
        this.toast_warn("今は部屋の外です")
      }
    },

    rsm_entry_handle() {
      this.$sound.play_click()

      this.new_room_key = _.trim(this.new_room_key)
      this.new_user_name = HandleNameNormalizer.normalize(this.new_user_name)

      {
        const message = RoomKeyValidator.valid_message(this.new_room_key)
        if (message) {
          this.toast_warn(message)
          return
        }
      }

      // ニックネームがNGであれば再入力を促す
      if (this.handle_name_invalid_then_toast_warn(this.new_user_name)) {
        return
      }

      this.room_create_by(this.new_room_key, this.new_user_name)

      if (this.auto_close_p) {
        this.sidebar_p = false
        this.rsm_close()
      }
    },
  },
  computed: {
  },
}
