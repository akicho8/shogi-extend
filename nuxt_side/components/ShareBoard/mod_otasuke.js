import _ from "lodash"

export const mod_otasuke = {
  methods: {
    // 「？」をクリックしたときの処理
    otasuke_click_handle() {
      this.$sound.play_click()
      let info = this.otasuke_current_message_info
      let message = info.message
      if (_.isArray(message)) {
        message = _.sample(message)
      }
      this.ac_log({subject: "おたすけ", body: message})
      this.toast_ok(message, {duration: 3 * 1000})
    },
  },
  computed: {
    // 「？」ボタン表示条件
    otasuke_button_show_p() {
      if (!this.debug_mode_p) { // あまり使われていないようなので通常モードでは表示しないようにする
        return false
      }
      if (this.edit_mode_p) {
        return false
      }
      if (this.otasuke_current_message_info == null) {
        return false
      }
      return true
    },
    // 「？」ボタンのアイコン
    otasuke_button_icon() {
      const info = this.otasuke_current_message_info
      if (info) {
        return info.icon
      }
    },
    // 表示メッセージと点滅情報のセットを返す
    otasuke_current_message_info() {
      let message = null
      let icon = "help"
      if (message == null) {
        if (this.ac_room == null) {
          message = [
            "対局する場合は部屋を立てよう",
            "詰将棋を作る場合は局面編集しよう",
            "Twitterアイコンで局面を投稿できるよ",
          ]
        }
      }
      if (message == null) {
        if (this.ac_room && !this.order_enable_p && this.uniq_member_infos.length < 2) {
          message = "次は部屋のリンクを仲間に伝えよう。リンクは「入退室」の中にあるよ"
          // icon = "play"
        }
      }
      if (message == null) {
        if (this.ac_room && !this.order_enable_p && this.uniq_member_infos.length >= 2) {
          message = "次は順番を設定しよう"
          // icon = "play"
        }
      }
      if (message == null) {
        if (this.ac_room && this.order_enable_p && !this.cc_play_p && this.current_turn >= 1 && this.honpu_main == null) {
          message = "対局時計をセットしてから対局しよう"
          // icon = "play"
        }
      }
      if (message == null) {
        if (this.ac_room && this.order_enable_p && !this.cc_play_p && this.current_turn >= 1 && this.honpu_main) {
          message = "検討する場合は順番設定も解除しよう"
          // icon = "play"
        }
      }

      // if (message == null) {
      //   if (this.ac_room && this.honpu_open_button_show_p && this.current_turn >= 1) {
      //     message = "初期配置に戻そう"
      //     icon = "play"
      //   }
      // }

      if (message == null) {
        if (this.ac_room && this.order_enable_p && !this.clock_box) {
          message = "次は対局時計を設置しよう"
          // icon = "play"
        }
      }
      if (message == null) {
        if (this.ac_room && this.order_enable_p && this.clock_box && !this.clock_box.play_p) {
          message = "時計をスタートして対局を始めよう"
          // icon = "play"
        }
      }
      if (message == null) {
        if (this.ac_room && this.clock_box && this.clock_box.play_p) {
          message = [
            // "投了は右上のチャットで発言しよう",
            // "タイトルを変更できるよ",
            "盤駒のスタイルを変更できるよ",
            "間違えたときは「1手戻す」で指し直そう (でも勝手にやると顰蹙を買うよ)",
            "自分の手番になると音が鳴るよ",
            "時間切れになっても続行できるよ",
            "チャットは観戦者だけに向けて発言できるよ",
            "履歴にはその時点までの棋譜が含まれているよ",
            "二歩が心配なときは順番設定で反則を「できない」にしよう",
            "「投了」すると「本譜」が出現するよ",
          ]
          message = null
        }
      }
      if (message) {
        return {
          message: message,
          icon: icon,
        }
      }
    },

    otasuke_single_line() {
      let message = null
      if (message == null) {
        if (this.ac_room && !this.order_enable_p && !this.cc_play_p && this.honpu_main) {
          message = "感想戦中"
        }
      }
      if (message == null) {
        if (this.ac_room && !this.order_enable_p && this.uniq_member_infos.length < 2) {
          message = "対戦相手待ち"
        }
      }
      if (message == null) {
        if (this.ac_room && !this.order_enable_p && this.uniq_member_infos.length >= 2) {
          message = "順番設定待ち"
        }
      }
      // if (message == null) {
      //   if (this.ac_room && this.order_enable_p && !this.cc_play_p && this.current_turn >= 1 && this.honpu_main == null) {
      //     message = "対局時計設置待ち"
      //   }
      // }
      // if (message == null) {
      //   if (this.ac_room && this.order_enable_p && !this.cc_play_p && this.current_turn >= 1 && this.honpu_main) {
      //     message = "検討する場合は順番設定も解除しよう"
      //     // icon = "play"
      //   }
      // }
      if (message == null) {
        if (this.ac_room && this.order_enable_p && !this.clock_box) {
          message = "対局時計設置待ち"
          // icon = "play"
        }
      }
      if (message == null) {
        if (this.ac_room && this.order_enable_p && this.clock_box && !this.clock_box.play_p) {
          message = "対局開始待ち"
          // icon = "play"
        }
      }
      // if (message == null) {
      //   if (this.ac_room && this.clock_box && this.clock_box.play_p) {
      //     message = [
      //       // "投了は右上のチャットで発言しよう",
      //       // "タイトルを変更できるよ",
      //       "盤駒のスタイルを変更できるよ",
      //       "間違えたときは「1手戻す」で指し直そう (でも勝手にやると顰蹙を買うよ)",
      //       "自分の手番になると音が鳴るよ",
      //       "時間切れになっても続行できるよ",
      //       "チャットは観戦者だけに向けて発言できるよ",
      //       "履歴にはその時点までの棋譜が含まれているよ",
      //       "二歩が心配なときは順番設定で反則を「できない」にしよう",
      //       "「投了」すると「本譜」が出現するよ",
      //     ]
      //     message = null
      //   }
      // }
      return message
    },
  },
}
