import TimeLimitModal from "./TimeLimitModal.vue"

const CC_TIME_LIMIT_BC_DELAY   = 0 // 当事者はN秒待って他者たちに時間切れをBCする (基本0。ネット遅延のシミューレートをする用)
const CC_AUTO_TIME_LIMIT_DELAY = 3 // 他の人は自分時計の判断で即座に時間切れを予約しN秒後にmodalを発動する

export const app_clock_box_time_limit = {
  data() {
    return {
      cc_auto_time_limit_delay_id: null, // モーダルを発動するまでのタイマーのID
      time_limit_modal_instance: null,   // モーダルを表示中ならそのインスタンス
    }
  },
  beforeDestroy() {
    this.time_limit_modal_close()
  },
  methods: {
    // 各自で時間切れが発動したときの処理
    // ここでいきなり時間切れにすると各端末で差が生まれるため時間を切らした1人がBCする
    // しかしそれでは端末を切って逃げると時間切れが伝わらない
    // そこで関係者は数秒待ってから自分で時間切れダイアログを【まだ表示されてなかったら】表示する
    // 2秒後に表示するつもりで1秒後にBCが届いたら2秒後の発動はキャンセルする
    cc_time_zero_callback() {
      if (this.ac_room && this.order_func_p) {
        if (this.current_turn_self_p) {
          this.cc_time_limit_modal_show_and_broadcast() // 当事者は発動してBC
        } else {
          this.cc_delayed_time_limit_modal()            // 他者は表示予約
        }
      } else {
        this.time_limit_modal_handle()
      }
    },

    // 当事者は自分で起動してBC
    cc_time_limit_modal_show_and_broadcast() {
      this.tl_alert("当事者は自分で起動してBC")
      this.time_limit_modal_handle()   // モーダルが発動しない0.1秒の間に指してしまうので本人にはすぐに表示する
      this.tl_add("TIME_LIMIT", `本人側 ${this.cc_time_limit_bc_delay}秒後にBC`)
      this.delay_block(this.cc_time_limit_bc_delay, () => {
        this.clock_box_share("時間切れ") // その上で、時間切れをBCする
      })
    },

    // 他者は表示予約
    // 数秒後以内にBCされたらそっちを優先してこちらはキャンセル
    cc_delayed_time_limit_modal() {
      if (this.time_limit_modal_instance) {
        // 当事者側の時間が進んでいて＆他者の時間が遅れている場合、
        // 当事者側がすぐにBCしてきてすでにモーダルを表示しているため何もしないでおく
        this.tl_add("TIME_LIMIT", `他者側 なんと予約する前に当事者からBCされてモーダルを表示していた`)
      } else {
        this.tl_alert("審議中")
        this.cc_auto_time_limit_delay_stop()
        this.cc_auto_time_limit_delay_id = this.delay_block(this.cc_auto_time_limit_delay, () => this.time_limit_modal_handle())
        this.tl_add("TIME_LIMIT", `他者側 自己判断で${this.cc_auto_time_limit_delay}秒後にmodal表示予約 (ID:${this.cc_auto_time_limit_delay_id})`)
      }
    },

    // 表示予約キャンセル
    cc_auto_time_limit_delay_stop() {
      if (this.cc_auto_time_limit_delay_id) {
        this.delay_stop(this.cc_auto_time_limit_delay_id)
        this.cc_auto_time_limit_delay_id = null
      }
    },

    // 時間切れがBCされたときに呼ぶ
    time_limit_modal_handle_if_not_exist() {
      if (this.time_limit_modal_instance) {
        this.tl_alert("BC受信時にはすでにモーダル起動済み")
      } else {
        this.tl_alert("BC受信によってモーダル起動開始")
        if (this.cc_auto_time_limit_delay_id) {
          this.tl_alert("時間切れ予約キャンセル")
        }
        this.time_limit_modal_handle()
      }
    },

    // 時間切れモーダル発動
    time_limit_modal_handle() {
      this.tl_alert("時間切れモーダル起動完了")
      this.sound_play("lose")         // ちーん

      this.time_limit_modal_close()
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
      this.cc_auto_time_limit_delay_stop() // 重要

      if (this.time_limit_modal_instance) {
        this.time_limit_modal_instance.close()
        this.time_limit_modal_instance = null
      }
    },
  },
  computed: {
    cc_auto_time_limit_delay() { return parseFloat(this.$route.query.CC_AUTO_TIME_LIMIT_DELAY || CC_AUTO_TIME_LIMIT_DELAY) },
    cc_time_limit_bc_delay()   { return parseFloat(this.$route.query.CC_TIME_LIMIT_BC_DELAY || CC_TIME_LIMIT_BC_DELAY)     },
  },
}
