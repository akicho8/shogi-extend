import _ from "lodash"

export const app_otasuke = {
  data() {
    return {
    }
  },
  methods: {
    otasuke_click_handle() {
      this.sound_play_click()
      let str = this.otasuke_current_message
      if (_.isArray(str)) {
        str = _.sample(str)
      }
      this.toast_ok(str, {duration: 3 * 1000})
    },
  },
  computed: {
    otasuke_button_show_p() {
      return this.otasuke_current_message != null
    },
    otasuke_current_message() {
      let message = null
      if (message == null) {
        if (this.ac_room == null) {
          message = [
            "対局する場合は右上メニューから部屋を立てよう",
            "詰将棋を作りたいときは右上メニューから局面編集だ",
            "右上の Twitter マークからSNSに局面を投稿できるぞ",
          ]
        }
      }
      if (message == null) {
        if (this.ac_room && !this.order_enable_p && this.name_uniq_member_infos.length < 2) {
          message = "次は部屋のリンクを仲間に伝えよう。リンクは「部屋に入る」の中にあるぞ"
        }
      }
      if (message == null) {
        if (this.ac_room && !this.order_enable_p && this.name_uniq_member_infos.length >= 2) {
          message = "次は右上メニューから順番設定をしよう"
        }
      }
      if (message == null) {
        if (this.ac_room && this.order_enable_p && this.otasuke_clock_off && this.current_turn >= 1) {
          message = "検討する場合は順番設定も解除しよう。もし今対局中なら時計を有効にして動かそう"
        }
      }
      if (message == null) {
        if (this.ac_room && this.order_enable_p && !this.clock_box) {
          message = "次は対局時計を設置しよう"
        }
      }
      if (message == null) {
        if (this.ac_room && this.order_enable_p && this.clock_box && !this.clock_box.working_p) {
          message = "次は対局時計を開始しよう"
        }
      }
      if (message == null) {
        if (this.ac_room && this.clock_box && this.clock_box.working_p) {
          message = [
            "投了は右上のチャットで発言しよう",
            "タイトルを変更できるぞ",
            "テーマで盤駒の見た目を変更できるぞ",
            "間違えたときは「1手戻す」で指し直そう。でも勝手にやると顰蹙を買うので注意だ",
            "自分の手番になると牛が鳴くぞ",
            "順番設定で反則できなくできるけど緊張感がなくなるぞ",
            "時間切れになっても続行できるけど何度もやると顰蹙を買うぞ",
            "チャットは観戦者だけに向けて発言できるぞ",
            "履歴にはその時点まで棋譜やメンバーの状態が含まれているぞ",
          ]
        }
      }
      return message
    },

    // 時計の状態: OFF, STOP, PAUSE のどれか
    otasuke_clock_off() {
      return this.clock_box == null || this.clock_box.stop_or_pause_p
    },
  },
}
