import { TimeLimitFuncInfo } from "../models/time_limit_func_info.js"
import { TimeLimitSecInfo  } from "../models/time_limit_sec_info.js"

export const mod_time_limit = {
  methods: {
    timeout_then_mistake() {
      if (this.time_limit_func_info.key === "time_limit_func_on") {
        if (this.timeout_p) {
          this.next_handle(this.AnswerKindInfo.fetch("mistake"))
        }
      }
    },
  },
  computed: {
    ////////////////////////////////////////////////////////////////////////////////

    TimeLimitFuncInfo()    { return TimeLimitFuncInfo                                 },
    time_limit_func_info() { return TimeLimitFuncInfo.fetch(this.time_limit_func_key) },

    TimeLimitSecInfo()     { return TimeLimitSecInfo                                  },

    ////////////////////////////////////////////////////////////////////////////////

    timeout_p() { return this.current_spent_sec >= this.time_limit_sec },
  },
}
