import TimeLimitModal from "./TimeLimitModal.vue"

const CC_AUTO_TIME_LIMIT_DELAY = 3 // 遅延を考慮してN秒だけ待つ

export const app_clock_box_time_limit = {
  data() {
    return {
      cc_time_limit_delay_id: null,    // TimeLimitModal を発動するまでのタイマーのID
      time_limit_modal_instance: null, // TimeLimitModal 表示中ならそのインスタンス
    }
  },
  beforeDestroy() {
    this.cc_time_limit_delay_stop()
    this.time_limit_modal_close()
  },
  methods: {
    // 各自で時間切れが発動したときの処理
    // ここでいきなり時間切れにすると各端末で差が生まれるため時間を切らした1人がブロードキャストする
    // しかしそれでは端末を切って逃げると時間切れが伝わらない
    // そこで関係者は数秒待ってから自分で時間切れダイアログを【まだ表示されてなかったら】表示する
    // 2秒後に表示するつもりで1秒後にブロードキャストが届いたら2秒後の発動はキャンセルする
    cc_time_zero_callback() {
      if (this.ac_room && this.order_func_p) {
        if (this.current_turn_self_p) {
          this.cc_time_limit_modal_show_and_broadcast() // 本人は自分で発動してブロードキャスト
        } else {
          this.cc_delayed_time_limit_modal()        // 他者は数秒後に自分で表示する
        }
      } else {
        this.time_limit_modal_handle()
      }
    },

    // 時間切れモーダル即座に表示して通知(本人)
    cc_time_limit_modal_show_and_broadcast() {
      this.debug_alert("当事者は自分で起動してブロードキャスト")
      this.time_limit_modal_handle()   // モーダルが発動しない0.1秒の間に指してしまうので本人にはすぐに表示する
      this.clock_box_share("時間切れ") // その上で、時間切れをブロードキャストする
    },

    // 時間切れモーダルを数秒後に発動させる(他者)
    // 数秒後以内にブロードキャストされたらそっちを優先してこちらはキャンセル
    cc_delayed_time_limit_modal() {
      this.toast_ok("審議中")
      this.cc_time_limit_delay_stop()
      this.cc_time_limit_delay_id = this.delay_block(this.cc_time_limit_delay, () => this.time_limit_modal_handle())
    },

    // 時間切れモーダルを数秒後に発動させる(他者) のキャンセル
    cc_time_limit_delay_stop() {
      if (this.cc_time_limit_delay_id) {
        this.delay_stop(this.cc_time_limit_delay_id)
        this.cc_time_limit_delay_id = null
      }
    },

    // 時間切れがブロードキャストされたときに呼ぶ
    time_limit_modal_handle_if_not_exist() {
      if (this.time_limit_modal_instance) {
        this.debug_alert("BC受信→モーダル起動済み")
        // 当事者 → 当事者 の場合は先に表示しているためこちらにくる
        // 当事者 → 他者 (3秒以上) の場合はこちら
      } else {
        // 当事者 → 他者 (3秒未満) の場合はこちら
        this.debug_alert("BC受信→モーダル起動開始")
        if (this.cc_time_limit_delay_id) {
          this.debug_alert("時間切れ予約キャンセル")
          this.cc_time_limit_delay_stop() // 今表示するのでもし数秒後に発動する予定になっていたものがあれば解除する
        }
        this.time_limit_modal_handle()
      }
    },

    // 時間切れモーダル発動
    time_limit_modal_handle() {
      this.sound_play("lose")         // ちーん

      this.cc_time_limit_delay_stop()

      // this.toast_ok("時間切れ")
      // this.ac_log("対局時計", "時間切れ")

      this.time_limit_modal_close() // 安全のため
      this.time_limit_modal_instance = this.$buefy.modal.open({
        component: TimeLimitModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        props: { base: this.base },
        onCancel: () => {
          this.sound_play("click")
          this.time_limit_modal_close()
        },
      })
    },

    time_limit_modal_close() {
      if (this.time_limit_modal_instance) {
        this.time_limit_modal_instance.close()
        this.time_limit_modal_instance = null
      }
    },
  },
  computed: {
    cc_time_limit_delay() { return parseInt(this.$route.query.CC_AUTO_TIME_LIMIT_DELAY || CC_AUTO_TIME_LIMIT_DELAY) },
  },
}
