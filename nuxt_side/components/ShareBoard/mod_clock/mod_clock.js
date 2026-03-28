import { mod_clock_box            } from "./mod_clock_box.js"
import { mod_clock_box_timeout    } from "./mod_clock_box_timeout.js"
import { mod_clock_decorator      } from "./mod_clock_decorator.js"
import { mod_persistent_cc_params } from "./mod_persistent_cc_params.js"
import { mod_clock_box_modal      } from "./mod_clock_box_modal.js"
import { clock_box_form           } from "./clock_box_form.js"

export const mod_clock = {
  mixins: [
    mod_clock_box,
    mod_clock_box_timeout,
    mod_clock_decorator,
    mod_persistent_cc_params,
    mod_clock_box_modal,
    clock_box_form,
  ],
}
