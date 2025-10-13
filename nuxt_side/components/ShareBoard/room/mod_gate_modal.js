import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import GateModal from "./GateModal.vue"
import { RoomKeyValidator } from "../models/room_key_validator.js"
import { HandleNameValidator } from "@/components/models/handle_name/handle_name_validator.js"
import { HandleNameNormalizer } from "@/components/models/handle_name/handle_name_normalizer.js"

export const mod_gate_modal = {
  data() {
    return {
      new_room_key: null,       // 入力中の合言葉
      new_user_name: null,      // 入力中のハンドルネーム
      gate_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.gate_modal_close()
  },
  methods: {
    gate_modal_open_handle() {
      if (this.gate_modal_instance == null) {
        this.sidebar_p = false
        this.sfx_click()
        this.gate_modal_open()
      }
    },

    gate_modal_close_handle() {
      if (this.gate_modal_instance) {
        this.sidebar_p = false
        this.sfx_click()
        this.gate_modal_close()
      }
    },

    gate_modal_open() {
      if (this.gate_modal_instance == null) {
        this.new_room_key = this.room_key
        this.new_user_name = this.user_name

        this.gate_modal_instance = this.modal_card_open({
          component: GateModal,
          onCancel: () => {
            this.sfx_click()
            this.gate_modal_close()
          },
        })
      }
    },

    gate_modal_close() {
      if (this.gate_modal_instance) {
        this.gate_modal_instance.close()
        this.gate_modal_instance = null
        this.debug_alert("GateModal close")
      }
    },

    gate_leave_handle() {
      this.sfx_click()
      if (this.ac_room == null) {
        this.toast_warn("今は部屋の外です")
        return
      }
      this.room_destroy()
    },

    gate_enter_handle() {
      this.sfx_click()

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

      if (this.auto_close_p) {
        this.sidebar_p = false
        this.gate_modal_close()
      }

      this.room_create_from_modal(this.new_room_key, this.new_user_name)
    },
  },
}
