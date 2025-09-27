import { ColorThemeInfo } from "../models/color_theme_info.js"

export const mod_color_theme = {
  data() {
    return {
      color_theme_loading: null,
    }
  },
  methods: {
    color_theme_key_change_handle(key) {
      this.sfx_click()
      this.color_theme_loading_start()
    },
    color_theme_item_click_handle(e) {
    },
    color_theme_image_load_handle(e, src) {
      this.color_theme_loading_close()
      this.debug_alert("読み込み成功")
      this.tl_add("配色", "読み込み成功", {event: e, src: src})
    },
    color_theme_image_error_handle(e, src) {
      this.color_theme_loading_close()
      this.debug_alert("読み込み失敗")
      this.tl_add("配色", "読み込み失敗", {event: e, src: src})
      this.toast_ng("画像の取得に失敗しました")
    },
    color_theme_loading_start() {
      this.color_theme_loading = this.$buefy.loading.open()
    },
    color_theme_loading_close() {
      if (this.color_theme_loading) {
        this.color_theme_loading.close()
        this.color_theme_loading = null
      }
    },
  },
  computed: {
    ColorThemeInfo()   { return ColorThemeInfo                             },
    color_theme_info() { return ColorThemeInfo.fetch(this.color_theme_key) },
  },
}
