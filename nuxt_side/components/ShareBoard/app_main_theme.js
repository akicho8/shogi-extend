import { MainThemeInfo } from "./models/main_theme_info.js"

export const app_main_theme = {
  data() {
    return {
      main_theme_loading: null,
    }
  },
  methods: {
    main_theme_key_change_handle(key) {
      this.sound_play_click()
      this.main_theme_loading_start()
    },
    main_theme_item_click_handle(e) {
    },
    main_theme_image_load_handle(e, src) {
      this.main_theme_loading_close()
      this.debug_alert("読み込み成功")
      this.tl_add("配色", "読み込み成功", {event: e, src: src})
    },
    main_theme_image_error_handle(e, src) {
      this.main_theme_loading_close()
      this.debug_alert("読み込み失敗")
      this.tl_add("配色", "読み込み失敗", {event: e, src: src})
      this.toast_ng("画像の取得に失敗しました")
    },
    main_theme_loading_start() {
      this.main_theme_loading = this.$buefy.loading.open()
    },
    main_theme_loading_close() {
      if (this.main_theme_loading) {
        this.main_theme_loading.close()
        this.main_theme_loading = null
      }
    },
  },
  computed: {
    MainThemeInfo()   { return MainThemeInfo                             },
    main_theme_info() { return MainThemeInfo.fetch(this.main_theme_key) },
  },
}
