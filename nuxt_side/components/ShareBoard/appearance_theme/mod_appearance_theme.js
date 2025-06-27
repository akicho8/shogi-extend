import { AppearanceThemeInfo } from "./appearance_theme_info.js"
import { MobileVerticalInfo } from "./mobile_vertical_info.js"

export const mod_appearance_theme = {
  computed: {
    AppearanceThemeInfo()   { return AppearanceThemeInfo                                  },
    appearance_theme_info() { return AppearanceThemeInfo.fetch(this.appearance_theme_key) },

    MobileVerticalInfo()   { return MobileVerticalInfo                                  },
    mobile_vertical_info() { return MobileVerticalInfo.fetch(this.mobile_vertical_key) },
  },
}
