import PerpetualModal from "./PerpetualModal.vue"
import { PerpetualCop } from "./perpetual_cop.js"

export const app_perpetual = {
  data() {
    return {
      perpetual_cop: PerpetualCop.create(),
      perpetual_modal_instance: null, // モーダルを表示中ならそのインスタンス
    }
  },

  beforeDestroy() {
    this.perpetual_modal_close()
  },

  methods: {
    //////////////////////////////////////////////////////////////////////////////// private

    // 条件に一致していたら発動する
    perpetual_modal_handle_if(cond) {
      if (cond && this.foul_behavior_info.perpetual_check_p) {
        this.perpetual_modal_handle()
      }
    },

    // モーダル発動
    perpetual_modal_handle() {
      this.$sound.play("lose")  // おおげさに「ちーん」にしておく
      this.perpetual_modal_close()
      this.perpetual_modal_instance = this.modal_card_open({
        component: PerpetualModal,
        props: {},
        onCancel: () => {
          this.$sound.play_click()
          this.perpetual_modal_close()
        },
      })
    },
    perpetual_modal_close() {
      if (this.perpetual_modal_instance) {
        this.perpetual_modal_instance.close()
        this.perpetual_modal_instance = null
      }
    },
  },
}
