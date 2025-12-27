// 可能であれば盤面の中に表示する

import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export const mod_toast = {
  methods: {
    sb_toast_primary(message, options = {}) {
      return this.sb_toast_primitive(message, {type: "is-primary", ...options})
    },

    sb_toast_warn(message, options = {}) {
      return this.sb_toast_primitive(message, {type: "is-warning", ...options})
    },

    sb_toast_danger(message, options = {}) {
      return this.sb_toast_primitive(message, {type: "is-danger", ...options})
    },

    async sb_toast_primitive(message, params = {}) {
      params = {
        container: this.sb_main_shogi_board_selector_for_toast,
        ...params,
      }
      throw new Error("must not happen")
      return this.toast_primitive(message, params)
    },
  },
}
