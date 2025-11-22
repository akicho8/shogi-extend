import TimeoutModal from "./TimeoutModal.vue"
import { GX } from "@/components/models/gx.js"

const CC_TIMEOUT_BC_DELAY    = 0  // 当事者はN秒待って他者たちに時間切れをBCする (基本0。ネット遅延のシミューレートをする用)
const CC_TIMEOUT_JUDGE_DELAY = 10 // 他の人は自分時計の判断で即座に時間切れを予約しN秒後にmodalを発動する

export const mod_clock_box_timeout = {
  data() {
    return {
      cc_timeout_modal_instance: null, // モーダルを表示中ならそのインスタンス
      cc_timeout_judge_delay_id: null, // モーダルを発動するまでのタイマーのID
    }
  },
  beforeDestroy() {
    this.cc_timeout_modal_close()
  },
  methods: {
    // 各自で時間切れが発動したときの処理
    // ここでいきなり時間切れにすると各端末で差が生まれるため時間を切らした1人がBCする
    // しかしそれでは端末を切って逃げると時間切れが伝わらない
    // そこで関係者は数秒待ってから自分で時間切れダイアログを【まだ表示されてなかったら】表示する
    // 2秒後に表示するつもりで1秒後にBCが届いたら2秒後の発動はキャンセルする
    cc_timeout_trigger() {
      if (this.ac_room && this.order_enable_p) {
        if (this.current_turn_self_p) {
          this.cc_timeout_modal_show_and_broadcast() // 当事者は発動してBC
        } else {
          this.cc_timeout_modal_show_later()            // 他者は表示予約
        }
      } else {
        this.cc_timeout_modal_open("self_notify")
      }
    },

    // 当事者は自分で起動してBC
    cc_timeout_modal_show_and_broadcast() {
      this.tl_alert("当事者は自分で起動してBC")
      this.auto_resign_then_give_up()           // 自動投了なら投了する
      this.cc_timeout_modal_open("self_notify") // モーダルが発動しない0.1秒の間に指してしまうので本人にはすぐに表示する
      this.tl_add("TIME_LIMIT", `本人側 ${this.CC_TIMEOUT_BC_DELAY}秒後にBC`)
      GX.delay_block(this.CC_TIMEOUT_BC_DELAY, () => {
        this.clock_box_share("cc_behavior_timeout")      // その上で、時間切れをBCする
      })
    },

    // 他者は表示予約
    // 数秒後以内にBCされたらそっちを優先してこちらはキャンセル
    cc_timeout_modal_show_later() {
      if (this.cc_timeout_modal_instance) {
        // 当事者側の時間が進んでいて＆他者の時間が遅れている場合、
        // 当事者側がすぐにBCしてきてすでにモーダルを表示しているため何もしないでおく
        this.tl_add("TIME_LIMIT", `他者側 なんと予約する前に当事者からBCされてモーダルを表示していた`)
      } else {
        this.al_add({from_user_name: this.current_turn_user_name, label: `←時間切れ？最大${this.CC_TIMEOUT_JUDGE_DELAY}秒待ち`})
        this.tl_alert("審議中")
        this.cc_timeout_judge_delay_stop()
        this.cc_timeout_judge_delay_id = GX.delay_block(this.CC_TIMEOUT_JUDGE_DELAY, () => this.cc_timeout_modal_open("audo_judge"))
        this.tl_add("TIME_LIMIT", `他者側 自己判断で${this.CC_TIMEOUT_JUDGE_DELAY}秒後にmodal表示予約 (ID:${this.cc_timeout_judge_delay_id})`)
      }
    },

    // 表示予約キャンセル
    cc_timeout_judge_delay_stop() {
      if (this.cc_timeout_judge_delay_id) {
        GX.delay_stop(this.cc_timeout_judge_delay_id)
        this.cc_timeout_judge_delay_id = null
      }
    },

    // 時間切れがBCされたときに呼ぶ
    cc_timeout_modal_open_if_not_exist() {
      if (this.cc_timeout_modal_instance) {
        this.tl_alert("BC受信時にはすでにモーダル起動済み")
      } else {
        this.tl_alert("BC受信によってモーダル起動開始")
        if (this.cc_timeout_judge_delay_id) {
          this.tl_alert("時間切れ予約キャンセル")
        }
        this.cc_timeout_modal_open("self_notify")
      }
    },

    // 時間切れモーダル発動
    cc_timeout_modal_open(timeout_key) {
      GX.assert(GX.present_p(timeout_key), "GX.present_p(timeout_key)")
      GX.assert(GX.present_p(this.clock_box), "GX.present_p(this.clock_box)")

      this.tl_alert("時間切れモーダル起動完了")
      this.sfx_stop_all()
      this.sfx_play("lose")         // ちーん

      this.cc_timeout_modal_close()
      this.cc_timeout_modal_instance = this.modal_card_open({
        component: TimeoutModal,
        props: {
          timeout_key: timeout_key,
        },
        canCancel: ["button", "escape"],
        onCancel: () => {
          this.sfx_click()
          this.cc_timeout_modal_close()
        },
      })
    },

    cc_timeout_modal_close() {
      this.cc_timeout_judge_delay_stop() // 重要

      if (this.cc_timeout_modal_instance) {
        this.cc_timeout_modal_instance.close()
        this.cc_timeout_modal_instance = null
      }
    },
  },
  computed: {
    CC_TIMEOUT_JUDGE_DELAY() { return this.param_to_f("CC_TIMEOUT_JUDGE_DELAY", CC_TIMEOUT_JUDGE_DELAY) },
    CC_TIMEOUT_BC_DELAY()    { return this.param_to_f("CC_TIMEOUT_BC_DELAY", CC_TIMEOUT_BC_DELAY)       },
  },
}
