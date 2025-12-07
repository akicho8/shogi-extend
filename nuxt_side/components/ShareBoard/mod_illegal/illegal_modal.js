import IllegalModal from "./IllegalModal.vue"
import { GX } from "@/components/models/gx.js"

export const illegal_modal = {
  data() {
    return {
      illegal_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.illegal_modal_close()
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// 反則 = したら負け

    // 一般モードの反則チェックありで自動的に指摘するときの処理
    // 反則モーダル発動
    illegal_modal_open_handle(illegal_hv_list) {
      if (GX.present_p(illegal_hv_list)) {
        this.sfx_stop_all()
        this.sfx_play("lose") // おおげさに「ちーん」にしておく
        // const str = params.illegal_hv_list.join("と")
        // this.toast_danger(`${str}の反則です`)
        // this.tl_alert("反則モーダル起動完了")
        // this.sfx_play("lose")         // ちーん
        this.illegal_modal_close()
        this.illegal_modal_instance = this.modal_card_open({
          component: IllegalModal,
          props: {
            illegal_hv_list: illegal_hv_list,
          },
          canCancel: ["button", "escape"],
          onCancel: () => {
            this.sfx_click()
            this.illegal_modal_close()
          },
        })
      }
    },

    illegal_modal_close_handle() {
      if (this.illegal_modal_instance) {
        this.sfx_click()
        this.illegal_modal_close()
      }
    },

    illegal_modal_close() {
      if (this.illegal_modal_instance) {
        this.illegal_modal_instance.close()
        this.illegal_modal_instance = null
      }
    },
  },
}
