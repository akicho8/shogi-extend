import SennichiteModal from "./SennichiteModal.vue"
import { SennichiteCop } from "./sennichite_cop.js"

export const app_sennichite = {
  data() {
    return {
      sennichite_cop: SennichiteCop.create(),
      sennichite_modal_instance: null, // モーダルを表示中ならそのインスタンス
    }
  },

  beforeDestroy() {
    this.sennichite_modal_close()
  },

  methods: {
    //////////////////////////////////////////////////////////////////////////////// private

    // モーダル発動
    sennichite_modal_handle_if(cond) {
      if (cond) {
        this.$sound.play("lose")  // おおげさに「ちーん」にしておく
        this.sennichite_modal_close()
        this.sennichite_modal_instance = this.modal_card_open({
          component: SennichiteModal,
          props: {},
          onCancel: () => {
            this.$sound.play_click()
            this.sennichite_modal_close()
          },
        })
      }
    },

    sennichite_modal_close() {
      if (this.sennichite_modal_instance) {
        this.sennichite_modal_instance.close()
        this.sennichite_modal_instance = null
      }
    },
  },
}
