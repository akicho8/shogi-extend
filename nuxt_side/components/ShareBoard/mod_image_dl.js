import ImageDlModal from "./ImageDlModal.vue"
import { ImageSizeInfo } from "./models/image_size_info.js"

export const mod_image_dl = {
  methods: {
    image_dl_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: ImageDlModal,
      })
    },

    image_size_key_change_handle() {
      this.$sound.play_click()
      this.color_theme_loading_start()
    },

    image_size_item_click_handle(e) {
    },

    image_dl_preview_url(options = {}) {
      return this.url_merge({
        format: "png",
        viewpoint: this.viewpoint,
        disposition: "inline",
        ...this.image_size_info.to_params,
        ...options,
      })
    },

    image_dl_run() {
      window.location.href = this.SB.image_dl_preview_url({disposition: "attachment"})
      this.SB.al_share_puts("画像ダウンロード")
    },
  },

  computed: {
    ImageSizeInfo()   { return ImageSizeInfo                            },
    image_size_info() { return ImageSizeInfo.fetch(this.image_size_key) },
  },
}
