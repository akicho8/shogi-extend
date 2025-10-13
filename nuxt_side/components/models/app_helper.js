import { HandleNameParser } from "@/components/models/handle_name/handle_name_parser.js"

export const AppHelper = {
  // as_full_url(path) {
  //   if (!path.match(/^http/)) {
  //     GX.assert(__NUXT__, "__NUXT__")
  //     path = __NUXT__.config.MY_SITE_URL + path
  //   }
  //   return path
  // },

  user_call_name(str) {
    return HandleNameParser.call_name(str)
  },

  // 単純に value があるかないかでクラスを割り振る
  has_content_class(value, options = {}) {
    options = {
      present_class: "is_content_present",
      blank_class: "is_content_blank",
      ...options,
    }
    if (this.$gs.present_p(value)) {
      return options.present_class
    } else {
      return options.blank_class
    }
  },
}
