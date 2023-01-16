import SntModal from "./SntModal.vue"
import { SntModel } from "./snt_model.js"

export const app_snt = {
  data() {
    return {
      snt_obj: SntModel.create(),
      snt_modal_instance: null, // モーダルを表示中ならそのインスタンス
    }
  },

  beforeDestroy() {
    this.snt_modal_close()
  },

  methods: {
    //////////////////////////////////////////////////////////////////////////////// private

    // モーダル発動
    snt_modal_handle_if(cond) {
      if (cond) {
        this.$sound.play("lose")  // おおげさに「ちーん」にしておく
        this.snt_modal_close()
        this.snt_modal_instance = this.modal_card_open({
          component: SntModal,
          props: {},
          onCancel: () => {
            this.$sound.play_click()
            this.snt_modal_close()
          },
        })
      }
    },

    snt_modal_close() {
      if (this.snt_modal_instance) {
        this.snt_modal_instance.close()
        this.snt_modal_instance = null
      }
    },
  },
}
