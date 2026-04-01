import ImageDownloadModal from "./ImageDownloadModal.vue"
import { ImageSizeInfo } from "../models/image_size_info.js"
import { mod_color_theme } from "./mod_color_theme.js"

export const mod_image_download = {
  mixins: [
    mod_color_theme,
  ],
  data() {
    return {
      image_download_success_count: 0,        // 正常にダウンロードができた場合にインクリメントしていく
    }
  },
  methods: {
    image_download_modal_handle() {
      this.sfx_click()
      this.modal_card_open({
        component: ImageDownloadModal,
      })
    },

    image_size_key_change_handle() {
      this.sfx_click()
      this.preview_image_loading_open()
    },

    image_size_item_click_handle(e) {
      if (this.debug_mode_p) {
        this.toast_primary(e.name)
      }
    },

    image_download_preview_url(options = {}) {
      return this.url_merge({
        format: "png",
        viewpoint: this.viewpoint,
        disposition: "inline",
        ...this.image_size_info.to_params,
        ...options,
      })
    },

    image_download_call() {
      window.location.href = this.image_download_preview_url({disposition: "attachment"})
      this.xhistory_puts("画像ダウンロード")
      this.image_download_success_count += 1
      this.toast_primary("画像をダウンロードしました")
    },
  },

  computed: {
    ImageSizeInfo()   { return ImageSizeInfo                            },
    image_size_info() { return ImageSizeInfo.fetch(this.image_size_key) },
  },
}
