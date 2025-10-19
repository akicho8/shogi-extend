import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export const mod_warning = {
  methods: {
    // 手番が違うのに操作しようとした
    // order_clock_both_ok でないときは sp_human_side に none を設定するため、その状態のとき盤駒を触られるとこれが呼ばれる
    ev_illegal_click_but_self_is_not_turn() {
      // 思考印モードの場合は無視する
      if (this.think_mark_mode_p) {
        return
      }

      // 観戦者なら思考印を常に有効とした場合に盤をつついたときは無視する
      if (this.think_mark_watcher_then_always_enable_p) {
        return
      }

      this.debug_alert("手番が違うのに操作しようとした")

      let message = null
      if (message == null) {
        if (this.inconsistency_order_only) {
          message = `対局するなら対局時計を押して検討するなら順番設定を解除してください`
        }
      }
      if (message == null) {
        if (this.inconsistency_clock_only) {
          message = `対局する場合は順番設定をしてください` // 本番でここにくることはないのだが同期の不整合でここに来てしまう場合がある
        }
      }
      if (message == null) {
        if (this.i_am_watcher_p) {
          message = `${this.my_call_name}は観戦者なので触らんといてください`
        }
      }
      if (message == null) {
        if (this.order_enable_p && this.current_turn_user_name == null) {
          message = `順番設定で対局者の指定がないので誰も操作できません` // ここにこさせるのはむつかしい
        }
      }
      if (message == null) {
        if (this.i_am_member_p) {
          message = `今は${this.user_call_name(this.current_turn_user_name)}の手番です`
        }
      }
      if (message) {
        this.sfx_play("se_tebanjanainoni_sawanna")
        this.common_warn_show(message)
        // this.toast_warn(message, {duration: 1000 * 5})
        // this.tl_add("OPVALID", message)
      }
    },

    // 自分が手番だが相手の駒を動かそうとした
    ev_illegal_my_turn_but_oside_click() {
      this.debug_alert("自分が手番だが相手の駒を動かそうとした")
      this.sfx_play("se_aitenokoma_sawannna")
      // this.common_warn_show(this.common_warn_message)
      // if (this.development_p) {
      //   this.toast_ok("それは相手の駒です")
      // }
    },

    // 順番設定ON 対局時計ON じゃないのに指したときの警告
    cc_not_use_battle_start_warn(params) {
      // const message = this.cc_not_use_battle_start_warn_message(params)
      // if (message) {
      //   this.toast_warn(message, {duration: 1000 * 5})
      // }

      // if (this.order_enable_p && !this.cc_play_p) {
      //   // this.sfx_click()
      //   // this.sb_talk(`ちょっと待って。途中の局面になっています。初期配置に戻してから開始しますか？`)
      //   this.dialog_alert({
      //     // type: "is-warning",
      //     // hasIcon: false,
      //     title: "警告",
      //     message: `
      //       <div class="content">
      //         <p>対局を開始していないのに${this.user_call_name(params.from_user_name)}が指しました。</p>
      //         <p>対局する場合は対局時計から対局開始してください。</p>
      //         <p>検討する場合は順番設定を解除してください。</p>
      //       </div>`,
      //     // type: "is-warning",
      //     // confirmText: "OK",
      //     // cancelText: `いいえ`,
      //     // focusOn: "confirm",
      //     // canCancel: ["button"],
      //     // ...params,
      //   })
      // }

      // this.common_warn_show(this.common_warn_message)
    },

    // cc_not_use_battle_start_warn_message(params) {
    //   let message = null
    //   if (this.order_enable_p) {
    //     // const turn_to = this.order_unit.main_user_count // 対局者数の数分の手数まで警告を出す
    //     // if (params.turn <= turn_to || true) {
    //     if (!this.cc_play_p) {
    //       message = `対局開始していないのに${this.user_call_name(params.from_user_name)}が指しました`
    //       message = `検討する場合は順番設定を解除してください`
    //     }
    //   }
    //   return message
    // },

    common_warn_show(message) {
      if (message) {
        this.ac_log({subject: "警告発動", body: message})
        this.toast_warn(message, {duration: 1000 * 5})
      }
    },
  },
  computed: {
    cc_start_even_though_order_is_not_enabled_p() { return this.ac_room && !this.order_enable_p }, // 順番設定を有効にしてないのに時計を開始しようとしている？

    // 不整合状態
    inconsistency_order_only() { return this.ac_room && this.order_enable_p  && !this.cc_play_p                          }, // 入室中に順番だけが有効になっている？
    inconsistency_clock_only() { return this.ac_room && !this.order_enable_p &&  this.cc_play_p                          }, // 入室中に時計だけが有効になっている？
    inconsistency_p()          { return this.ac_room && (this.inconsistency_order_only || this.inconsistency_clock_only) }, // つまり不整合な状態か？

    // 整合性取れている状態
    order_clock_both_ok()    { return this.order_enable_p && this.cc_play_p   },                 // 両方ON
    order_clock_both_empty() { return !this.order_enable_p && !this.cc_play_p },                 // 両方OFF
    integrity_ok_p()         { return this.order_clock_both_ok || this.order_clock_both_empty }, // どちらか

    // // 手番で指したときと手番でないのに指したときの共通のバリデーション
    // common_warn_message() {
    //   let message = null
    //   if (message == null) {
    //     if (!this.order_enable_p && this.cc_play_p) {
    //       message = `対局する場合は順番設定をしてください` // 本番でここにくることはないのだが同期の不整合でここに来てしまう場合がある
    //     }
    //   }
    //   if (message == null) {
    //     if (this.order_enable_p && !this.cc_play_p) {
    //       message = `対局するなら対局時計を押して検討するなら順番設定を解除してください`
    //     }
    //   }
    //   return message
    // },
  },
}
