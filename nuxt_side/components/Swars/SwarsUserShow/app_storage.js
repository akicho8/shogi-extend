import { params_controller } from "@/components/params_controller.js"
import { ParamInfo } from "./models/param_info.js"

export const app_storage = {
  mixins: [params_controller],

  data() {
    return {
      ...ParamInfo.null_value_data_hash,
    }
  },

  // computed: {
  //   ls_storage_key() {
  //     return "swars/battles/index"
  //   },
  // },
}

// import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"
//
// export const app_storage = {
//   mixins: [
//     ls_support_mixin,
//   ],
//   data() {
//     return {
//       tab_index: null,
//     }
//   },
//   computed: {
//     ls_default() {
//       return {
//         tab_index: 0,
//       }
//     },
//   },
// }
