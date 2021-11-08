import ImageDlModal from "./ImageDlModal.vue"
import { ImageSizeInfo } from "./models/image_size_info.js"

export const app_image_dl = {
  methods: {
    image_dl_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: ImageDlModal,
        props: { base: this.base },
      })
    },

    image_size_key_change_handle() {
      this.sound_play_click()
      this.color_theme_loading_start()
    },

    image_size_item_click_handle(e) {
    },

    image_dl_preview_url(options = {}) {
      return this.permalink_for({
        format: "png",
        abstract_viewpoint: this.sp_viewpoint,
        disposition: "inline",
        ...this.image_size_info.to_params,
        ...options,
      })
    },

    image_dl_run() {
      window.location.href = this.base.image_dl_preview_url({disposition: "attachment"})
      this.base.shared_al_add_simple("画像ダウンロード")
    },
  },

  computed: {
    ImageSizeInfo()   { return ImageSizeInfo                            },
    image_size_info() { return ImageSizeInfo.fetch(this.image_size_key) },
  },
}
