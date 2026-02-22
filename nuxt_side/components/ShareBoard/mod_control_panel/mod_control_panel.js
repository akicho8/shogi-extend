import { mod_sidebar } from "./mod_sidebar.js"
import { StartStepInfo } from "./start_step_info.js"

export const mod_control_panel = {
  mixins: [
    mod_sidebar,
  ],
  computed: {
    step1_todo_p() { return !this.ac_room                                                           },
    step1_done_p() { return this.ac_room                                                            },

    step2_todo_p() { return this.step1_done_p && (!this.order_enable_p || !this.order_flow.valid_p) },
    step2_done_p() { return this.step1_done_p && this.order_enable_p && this.order_flow.valid_p     },

    step3_todo_p() { return this.step2_done_p && !this.cc_play_p                                    },
    step3_done_p() { return this.step2_done_p && this.cc_play_p                                     },

    start_steps() {
      return StartStepInfo.values
    }
  },
}
