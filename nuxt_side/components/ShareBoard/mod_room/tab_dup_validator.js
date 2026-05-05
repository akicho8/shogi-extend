import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import TabDupModal from "./TabDupModal.vue"
import { TabDupInfo } from "./tab_dup_info.js"

export const tab_dup_validator = {
  data() {
    return {
      tab_dup_key: null,
    }
  },
  beforeDestroy() {
    this.tab_dup_modal_close()
  },
  methods: {
    tab_dup_validate_call(params) {
      const key = this.tab_dup_key_detect(params)
      if (key) {
        this.tab_dup_modal_open_by(key)
      }
    },

    // 「同じ名前」「client_token が同じ」「connection_id が異なる」場合にタブが複数開いている
    tab_dup_key_detect(params) {
      for (const e of this.member_infos) {
        const same_name    = e.from_user_name === this.user_name          // 同じ名前の人がいる
        const same_browser = e.client_token === this.client_token         // 一つのPCの一つのブラウザからアクセスしている
        const dup_tab      = e.from_connection_id !== this.connection_id  // タブが異なる
        if (same_name && dup_tab) {
          if (same_browser) {
            return "td_tab"
          } else {
            return "td_pc"
          }
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    tab_dup_modal_open_td_tab() {
      this.tab_dup_modal_open_by("td_tab")
    },

    tab_dup_modal_open_td_pc() {
      this.tab_dup_modal_open_by("td_pc")
    },

    ////////////////////////////////////////////////////////////////////////////////

    tab_dup_modal_close_handle() {
      if (this.tab_dup_modal_instance) {
        this.sfx_click()
        this.tab_dup_modal_close()
        this.tab_dup_key = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    tab_dup_modal_open_by(tab_dup_key) {
      if (!this.tab_dup_modal_instance) {
        this.tab_dup_key = tab_dup_key
        this.sfx_play("x")
        this.sb_talk(this.tab_dup_info.talk_body)
        this.ac_log({subject: "接続重複", body: this.tab_dup_info.name})
        this.modal_card_open2("tab_dup_modal_instance", {
          component: TabDupModal,
        })
      }
    },

    tab_dup_modal_close() {
      if (this.tab_dup_modal_instance) {
        this.modal_card_close2("tab_dup_modal_instance")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },

  computed: {
    tab_dup_info() { return TabDupInfo.lookup(this.tab_dup_key) },
  },
}
