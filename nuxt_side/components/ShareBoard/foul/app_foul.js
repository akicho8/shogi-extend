import FoulModal from "./FoulModal.vue"

export const app_foul = {
  data() {
    return {
      latest_foul_name:    null, // 初心者モードで最後に自分がした反則の日本語名(system test 用)
      foul_modal_instance: null, // モーダルを表示中ならそのインスタンス
    }
  },

  beforeDestroy() {
    this.foul_modal_close()
  },

  methods: {
    // 初心者モードの反則チェックありだけど反則できないときに反則したときの処理
    // ここは何もしなければ将棋ウォーズのようになる
    foul_accident_handle(attrs) {
      this.$sound.play("x")               // 自分だけに軽く知らせる
      this.latest_foul_name = attrs.name // デバッグ用
      this.toast_ng(attrs.name)          // "二歩"
    },

    // 一般モードの反則チェックありで自動的に指摘するときの処理
    // 反則モーダル発動
    foul_modal_handle(foul_names) {
      if (this.present_p(foul_names)) {
        this.$sound.play("lose") // おおげさに「ちーん」にしておく
        // const str = params.lmi.foul_names.join("と")
        // this.toast_ng(`${str}の反則です`)
        // this.tl_alert("反則モーダル起動完了")
        // this.$sound.play("lose")         // ちーん
        this.foul_modal_close()
        this.foul_modal_instance = this.modal_card_open({
          component: FoulModal,
          props: {
            foul_names: foul_names,
          },
          onCancel: () => {
            this.$sound.play_click()
            this.foul_modal_close()
          },
        })
      }
    },

    foul_modal_close() {
      if (this.foul_modal_instance) {
        this.foul_modal_instance.close()
        this.foul_modal_instance = null
      }
    },
  },
}
