import { AppearanceThemeInfo } from "./appearance_theme_info.js"
import { MobileLayoutInfo } from "./mobile_layout_info.js"

export const mod_appearance_theme = {
  computed: {
    AppearanceThemeInfo()   { return AppearanceThemeInfo                                  },
    appearance_theme_info() { return AppearanceThemeInfo.fetch(this.appearance_theme_key) },

    MobileLayoutInfo()   { return MobileLayoutInfo                                  },
    mobile_layout_info() { return MobileLayoutInfo.fetch(this.mobile_layout_key) },
  },
}
