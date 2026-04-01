import { ColorThemeInfo } from "@/components/models/color_theme_info.js"

export const mod_color_theme = {
  beforeDestroy() {
    this.preview_image_loading_close()
  },
  methods: {
    preview_image_load_handle(e, src) {
      this.preview_image_loading_close()
      this.debug_alert("読み込み成功")
      this.tl_add("配色", "読み込み成功", {event: e, src: src})
    },
    preview_image_error_handle(e, src) {
      this.preview_image_loading_close()
      this.debug_alert("読み込み失敗")
      this.tl_add("配色", "読み込み失敗", {event: e, src: src})
      this.toast_danger("画像の取得に失敗しました")
    },

    ////////////////////////////////////////////////////////////////////////////////

    color_theme_key_change_handle(key) {
      this.sfx_click()
      this.preview_image_loading_open()
    },
    color_theme_item_click_handle(e) {
      this.talk(e.name)
    },

    ////////////////////////////////////////////////////////////////////////////////

    preview_image_loading_open() {
      if (!this.preview_image_loading_instance) {
        this.preview_image_loading_instance = this.$buefy.loading.open()
      }
    },
    preview_image_loading_close() {
      if (this.preview_image_loading_instance) {
        this.preview_image_loading_instance.close()
        this.preview_image_loading_instance = null
      }
    },
  },
  computed: {
    ColorThemeInfo()   { return ColorThemeInfo                             },
    color_theme_info() { return ColorThemeInfo.fetch(this.color_theme_key) },
  },
}
