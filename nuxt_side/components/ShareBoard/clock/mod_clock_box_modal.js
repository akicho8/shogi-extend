import { GX } from "@/components/models/gx.js"
import _ from "lodash"
import { CcSoftValidatorInfo } from "./cc_soft_validator_info.js"

import ClockBoxModal from "./ClockBoxModal.vue"

export const mod_clock_box_modal = {
  data() {
    return {
      cc_modal_instance: null,
    }
  },

  beforeDestroy() {
    this.cc_modal_close()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    cc_play_pause_resume_shortcut_handle() {
      if (this.clock_box) {
        if (false) {
        } else if (this.clock_box.stop_p) {
          if (this.debug_mode_p) {
            this.debug_alert("開始")
            this.cbm_play_handle()
            this.cc_modal_close()
          }
        } else if (this.clock_box.play_p) {
          this.debug_alert("一時停止")
          this.cbm_pause_handle()
          this.cc_modal_open()
        } else if (this.clock_box.pause_p) {
          this.debug_alert("再開")
          this.cbm_resume_handle()
          this.cc_modal_close()
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    cc_modal_open_handle() {
      if (this.cc_modal_instance == null) {
        this.sidebar_close()
        this.sfx_click()
        this.cc_modal_open()
      }
    },

    cc_modal_open() {
      if (this.cc_modal_instance == null) {
        this.cc_modal_instance = this.modal_card_open({
          component: ClockBoxModal,
          onCancel: () => {
            this.sfx_click()
            this.cc_modal_close()
          },
        })
      }
    },

    cc_modal_close_handle() {
      if (this.cc_modal_instance) {
        this.sidebar_close()
        this.sfx_click()
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
      this.sfx_play_toggle(v)
      this.cc_main_switch_set(v)
    },

    cbm_play_handle() {
      if (this.cc_start_even_though_order_is_not_enabled_p && !this.debug_mode_p) {
        this.sfx_click()
        this.toast_ng("先に順番設定をしてください")
        return
      }

      // いったん初期配置に戻すか聞く
      // 二歩で対局が終わって、再度順番設定と時計を指定して再開するケースもあるため、これはない方がよい
      if (this.current_turn >= 1 && this.AppConfig.CLOCK_START_CONFIRM) {
        this.cc_play_confirim({
          onCancel: () => {
            this.toast_ok(`途中の局面から対局を開始しました`)
            this.cbm_play_core_handle()
          },
          onConfirm: () => {
            this.force_sync_turn_zero()
            this.cbm_play_core_handle()
          },
        })
        return
      }

      this.cbm_play_core_handle()
    },
    cbm_play_core_handle() {
      // this.$GX.assert(this.clock_box == null, "this.clock_box == null") ← この assert はまちがい
      this.sfx_click()
      this.cc_params_apply()
      this.cc_play_handle()
      this.clock_box_share("cc_behavior_start")
      if (this.auto_close_p) {
        this.cc_modal_close()
      }
    },
    cbm_pause_handle() {
      this.sfx_click()
      this.cc_pause_handle()
      this.clock_box_share("cc_behavior_pause")
      // if (this.ac_room && this.order_enable_p) {
      //   this.$GX.delay_block(2.5, () => this.toast_ok("続けて検討する場合は順番設定を解除してください"))
      // }
    },
    cbm_stop_handle() {
      this.sfx_click()
      if (this.clock_box.pause_or_play_p) {
        this.cc_stop_handle()
        this.clock_box_share("cc_behavior_stop")
      } else {
        this.toast_ok("すでに停止しています")
      }
    },
    cbm_resume_handle() {
      this.sfx_click()
      this.cc_resume_handle()
      this.clock_box_share("cc_behavior_resume")
      if (this.auto_close_p) {
        this.cc_modal_close()
      }
    },
    cbm_save_handle() {
      this.sfx_click()
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
      this.sfx_play_toggle(value)
      this.cc_unique_mode_set(value)
    },

  },

  computed: {
    cc_soft_validator_info() {
      let info = null
      if (this.cc_params) {
        this.cc_params.forEach(params => {
          if (info == null) {
            const matched = CcSoftValidatorInfo.match(params)
            if (matched) {
              info = matched
              // 本当はここで break したいがクソ言語はできない
            }
          }
        })
      }
      return info
    }
  },
}
