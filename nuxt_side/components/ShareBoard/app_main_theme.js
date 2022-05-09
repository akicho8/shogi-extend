import { MainThemeInfo } from "./models/main_theme_info.js"

export const app_main_theme = {
  computed: {
    MainThemeInfo()   { return MainThemeInfo                            },
    main_theme_info() { return MainThemeInfo.fetch(this.main_theme_key) },
  },
}
