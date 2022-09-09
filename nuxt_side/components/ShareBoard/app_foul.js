export const app_foul = {
  data() {
    return {
      latest_foul_name: null, // 初心者モードで最後に自分がした反則の日本語名
    }
  },

  methods: {
    // 初心者モードの反則チェックありだけど反則できないときに反則したときの処理
    // ここは何もしなければ将棋ウォーズのようになる
    foul_accident_handle(attrs) {
      this.sound_play("x")               // 自分だけに軽く知らせる
      this.latest_foul_name = attrs.name // デバッグ用
      this.toast_ng(attrs.name)          // "二歩"
    },

    // 一般モードの反則チェックありで自動的に指摘するときの処理
    foul_show(params) {
      if (this.present_p(params.lmi.foul_names)) {
        this.sound_play("lose") // おおげさに「ちーん」にしておく
        const str = params.lmi.foul_names.join("と")
        this.toast_ng(`${str}の反則です`)
      }
    },
  },
}
