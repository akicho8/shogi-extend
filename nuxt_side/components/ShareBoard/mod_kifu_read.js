import KifuReadModal from "@/components/KifuReadModal.vue"
import { GX } from "@/components/models/gx.js"

export const mod_kifu_read = {
  data() {
    return {
      $kifu_read_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.kifu_read_modal_close()
  },
  methods: {
    // クリップボードから読み込む
    async kifu_read_from_clipboard() {
      if (navigator.clipboard) {
        const text = await navigator.clipboard.readText()
        this.kifu_read_modal_open_or_direct_handle(text)
        return true
      }
    },

    // 部屋を作っている場合はモーダルに読み込む
    kifu_read_modal_open_or_direct_handle(text) {
      if (this.ac_room == null) {
        this.kifu_read_direct_handle(text)
      } else {
        this.kifu_read_modal_open_handle(text)
      }
    },

    // 棋譜の読み込みタップ時の処理
    kifu_read_modal_open_handle(source = "") {
      if (!this.$kifu_read_modal_instance) {
        this.sidebar_close()
        this.sfx_click()
        if (this.cc_play_p) {
          this.toast_primary("対局中は読み込めません")
          return
        }
        this.kifu_read_modal_open(source)
      }
    },

    kifu_read_modal_open(source = "") {
      if (!this.$kifu_read_modal_instance) {
        this.$kifu_read_modal_instance = this.modal_card_open({
          component: KifuReadModal,
          props: {
            source: source,
          },
          events: {
            "update:any_source": any_source => {
              this.kifu_read_direct_handle(any_source)
            },
            "close": () => this.kifu_read_modal_close(),
          },
          onCancel: () => {
            this.sfx_click()
            this.kifu_read_modal_close()
          },
        })
      }
    },

    kifu_read_modal_close() {
      if (this.$kifu_read_modal_instance) {
        this.$kifu_read_modal_instance.close()
        this.$kifu_read_modal_instance = null
      }
    },

    // 棋譜読み込み処理
    async kifu_read_direct_handle(any_source) {
      const params = {
        any_source: any_source,
        to_format: "sfen",
      }
      const e = await this.$axios.$post("/api/general/any_source_to.json", params)
      this.bs_error_message_dialog(e)
      if (e.body) {
        this.kifu_read_modal_close()
        this.current_sfen_set({sfen: e.body, turn: e.turn_max})
        this.honpu_master_setup()           // 読み込んだ棋譜を本譜とする
        this.honpu_share()                // それを他の人に共有する
        this.viewpoint = "black"          // 視点を黒に戻す
        this.reflector_call({message: `棋譜を読み込みました`, label: "棋譜読込"})
      }
    },
  },
}
