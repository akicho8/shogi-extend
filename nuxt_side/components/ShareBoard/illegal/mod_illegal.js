import IllegalModal from "./IllegalModal.vue"

export const mod_illegal = {
  data() {
    return {
      latest_illegal_name:    null, // 初心者モードで最後に自分がした反則の日本語名(system test 用)
      illegal_modal_instance: null, // モーダルを表示中ならそのインスタンス
    }
  },

  beforeDestroy() {
    this.illegal_modal_close()
  },

  methods: {
    // 初心者モードの反則チェックありだけど反則できないときに反則したときの処理
    // ここは何もしなければ将棋ウォーズのようになる
    ev_illegal_illegal_accident(attrs) {
      this.$sound.play("x")               // 自分だけに軽く知らせる
      this.latest_illegal_name = attrs.name // デバッグ用
      this.toast_ng(attrs.name)          // "二歩"
    },

    // 一般モードの反則チェックありで自動的に指摘するときの処理
    // 反則モーダル発動
    illegal_modal_handle(illegal_names) {
      if (this.$gs.present_p(illegal_names)) {
        this.$sound.play("lose") // おおげさに「ちーん」にしておく
        // const str = params.lmi.illegal_names.join("と")
        // this.toast_ng(`${str}の反則です`)
        // this.tl_alert("反則モーダル起動完了")
        // this.$sound.play("lose")         // ちーん
        this.illegal_modal_close()
        this.illegal_modal_instance = this.modal_card_open({
          component: IllegalModal,
          props: {
            illegal_names: illegal_names,
          },
          onCancel: () => {
            this.$sound.play_click()
            this.illegal_modal_close()
          },
        })
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
