import { XstatusInfo } from "./xstatus_info.js"
import _ from "lodash"

export const mod_xstatus = {
  computed: {
    xstatus_message() {
      const xstatus_info = XstatusInfo.values.find(e => e.if_cond(this))
      if (xstatus_info) {
        return xstatus_info.message
      }
    },
  },
}
