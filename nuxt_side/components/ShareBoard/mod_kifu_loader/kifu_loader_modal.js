import KifuLoaderModal from "@/components/KifuLoaderModal.vue"
import { GX } from "@/components/models/gx.js"

export const kifu_loader_modal = {
  beforeDestroy() {
    this.kifu_loader_modal_close()
  },
  methods: {
    // クリップボードから読み込む
    async kifu_load_from_clipboard() {
      if (navigator.clipboard) {
        const text = await navigator.clipboard.readText()
        this.__kifu_loader_modal_open_or_direct_handle(text)
        return true
      }
    },

    // 部屋を作っている場合はモーダルに読み込む
    __kifu_loader_modal_open_or_direct_handle(text) {
      if (this.cable_p) {
        this.kifu_loader_modal_open_handle(text)
      } else {
        this.kifu_read_direct_handle(text)
      }
    },

    // 棋譜の読み込みタップ時の処理
    kifu_loader_modal_open_handle(source = "") {
      if (!this.kifu_loader_modal_instance) {
        this.sfx_click()
        if (this.cc_play_p) {
          this.toast_primary("対局中は読み込めません")
          return
        }
        this.kifu_loader_modal_open(source)
      }
    },

    kifu_loader_modal_open(source = "") {
      if (!this.kifu_loader_modal_instance) {
        this.kifu_loader_modal_instance = this.modal_card_open({
          component: KifuLoaderModal,
          props: {
            source: source,
          },
          events: {
            "update:any_source": (any_source) => this.kifu_read_direct_handle(any_source),
            "close": () => this.kifu_loader_modal_close(),
          },
          onCancel: () => {
            this.sfx_click()
            this.kifu_loader_modal_close()
          },
        })
      }
    },

    kifu_loader_modal_close() {
      if (this.kifu_loader_modal_instance) {
        this.kifu_loader_modal_instance.close()
        this.kifu_loader_modal_instance = null
      }
    },
  },
}
