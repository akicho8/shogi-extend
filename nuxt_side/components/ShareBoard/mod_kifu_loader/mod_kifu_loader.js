import KifuLoaderModal from "@/components/KifuLoaderModal.vue"
import { kifu_loader_modal } from "./kifu_loader_modal.js"
import { GX } from "@/components/models/gx.js"

export const mod_kifu_loader = {
  mixins: [
    kifu_loader_modal,
  ],
  methods: {
    // 棋譜読み込み処理
    async kifu_read_direct_handle(any_source) {
      const params = {
        any_source: any_source,
        to_format: "sfen",
        __ERROR_THEN_STATUS_200__: true,
      }
      const e = await this.$axios.$post("/api/general/any_source_to.json", params)
      this.bioshogi_error_modal_open(e)
      if (e.body) {
        this.kifu_set({sfen: e.body, turn: e.turn_max})
      }
    },

    // 棋譜読み込み処理
    kifu_set(sfen_and_turn) {
      if (this.cc_play_then_warning()) { return }
      this.kifu_loader_modal_close()
      this.battle_list_modal_close()
      this.sidebar_close()                 // サイドバーで何かすることはないので閉じる
      this.current_sfen_set(sfen_and_turn) // 反映
      this.viewpoint = "black"             // 視点を黒に戻す
      this.honpu_master_setup()            // 読み込んだ棋譜を本譜とする
      this.honpu_share()                   // それを他の人に共有する
      this.reflector_call({message: `棋譜を読み込みました`, label: "棋譜読込"})
    },
  },
}
