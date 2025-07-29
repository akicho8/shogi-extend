import { Gs } from "@/components/models/gs.js"
import _ from "lodash"

import ClockBoxModal  from "./ClockBoxModal.vue"

export const mod_clock_box_modal = {
  data() {
    return {
      cc_modal_instance: null,
    }
  },

  beforeDestroy() {
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    cc_modal_open_handle() {
      if (this.cc_modal_instance == null) {
        this.sidebar_p = false
        this.$sound.play_click()

        this.cc_modal_instance = this.modal_card_open({
          component: ClockBoxModal,
          onCancel: () => {
            this.$sound.play_click()
            this.cc_modal_close()
          },
        })
      }
    },

    cc_modal_close_handle() {
      if (this.cc_modal_instance) {
        this.sidebar_p = false
        this.$sound.play_click()
        this.cc_modal_close()
      }
    },

    cc_modal_close() {
      if (this.cc_modal_instance) {
        this.cc_modal_instance.close()
        this.cc_modal_instance = null
        this.debug_alert("ClockBoxModal close")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    cbm_main_switch_handle(v) {
      this.$sound.play_toggle(v)
      this.cc_main_switch_set(v)
    },

    cbm_play_handle() {
      if (this.cc_start_even_though_order_is_not_enabled_p && !this.debug_mode_p) {
        this.$sound.play_click()
        this.toast_ng("先に順番設定をしてください")
        return
      }

      // いったん初期配置に戻すか聞く
      if (this.current_turn >= 1) {
        this.cc_play_confirim({
          onCancel: () => {
            this.$sound.play_click()
            this.toast_ok("メニューの中の上の方に「初期配置に戻す」があります")
          },
          onConfirm: () => {
            this.cbm_play_core_handle()
            // this.$sound.play_click()
            // this.force_sync_turn_zero()
            // this.cbm_play_core_handle()
          },
        })
        return
      }

      this.cbm_play_core_handle()
    },
    cbm_play_core_handle() {
      this.$gs.assert(this.clock_box == null, "this.clock_box == null")
      this.$sound.play_click()
      this.cc_params_apply()
      this.cc_play_handle()
      this.clock_box_share("cc_behavior_start")
      if (this.auto_close_p) {
        this.cc_modal_close()
      }
    },
    cbm_pause_handle() {
      this.$sound.play_click()
      this.cc_pause_handle()
      this.clock_box_share("cc_behavior_pause")
      if (this.ac_room && this.order_enable_p) {
        this.$gs.delay_block(2.5, () => this.toast_ok("続けて検討する場合は順番設定を無効にしてください"))
      }
    },
    cbm_stop_handle() {
      this.$sound.play_click()
      if (this.clock_box.pause_or_play_p) {
        this.cc_stop_handle()
        this.clock_box_share("cc_behavior_stop")
      } else {
        this.toast_ok("すでに停止しています")
      }
    },
    cbm_resume_handle() {
      this.$sound.play_click()
      this.cc_resume_handle()
      this.clock_box_share("cc_behavior_resume")
      if (this.auto_close_p) {
        this.cc_modal_close()
      }
    },
    cbm_save_handle() {
      this.$sound.play_click()
      this.cc_params_apply()
      this.toast_ok("反映しました")
    },
    cbm_cc_params_set_handle(e) {
      this.cc_params = e.cc_params   // cloneDeep したものを渡している
      if (false) {
        this.toast_ok(`${e.name}のプリセットを読み込みました`)
      } else {
        this.toast_ok(`読み込みました`, {talk: false})
      }
    },
    cbm_cc_unique_mode_sete_handle(value) {
      this.$sound.play_toggle(value)
      this.cc_unique_mode_set(value)
    },
  },
  computed: {
  },
}
