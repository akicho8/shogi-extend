import { AppearanceThemeInfo } from "./models/appearance_theme_info.js"

export const app_appearance_theme = {
  computed: {
    AppearanceThemeInfo()   { return AppearanceThemeInfo                            },
    appearance_theme_info() { return AppearanceThemeInfo.fetch(this.appearance_theme_key) },
  },
}
