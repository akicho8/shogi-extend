import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export const mod_warning = {
  methods: {
    // 手番が違うのに操作しようとした
    // order_clock_both_ok でないときは sp_human_side に none を設定するため、その状態のとき盤駒を触られるとこれが呼ばれる
    async ev_illegal_click_but_self_is_not_turn() {
      // 思考印モードの場合は無視する
      if (this.think_mark_mode_p) {
        return
      }

      // 観戦者なら思考印を常に有効とした場合に盤をつついたときは無視する
      if (this.think_mark_watcher_then_always_enable_p) {
        return
      }

      this.debug_alert("手番が違うのに操作しようとした")

      const message = this.ev_illegal_click_but_self_is_not_turn_message
      if (message) {
        this.sfx_play("se_tebanjanainoni_sawanna")
        this.ac_log({subject: "警告発動", body: message})
        for (const message of _.castArray(message)) { // クソ言語は forEach にすると await が使えない
          await this.toast_warn(message, { duration: 1000 * 5 })
        }
      }
    },

    ev_illegal_my_turn_but_oside_click() {
      this.debug_alert("自分が手番だが相手の駒を動かそうとした")
      this.sfx_play("se_aitenokoma_sawannna")
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

    ev_illegal_click_but_self_is_not_turn_message() {
      let message = null
      if (message == null) {
        if (this.inconsistency_order_only) {
          message = [
            `対局するんなら対局時計を押そう`,
            `検討するんなら駒を動かせるように順番設定を解除しよう`,
          ]
        }
      }
      if (message == null) {
        if (this.inconsistency_clock_only) {
          message = `対局する場合は順番設定しよう` // 本番でここにくることはないのだが同期の不整合でここに来てしまう場合がある
        }
      }
      if (message == null) {
        if (this.i_am_watcher_p) {
          message = [
            `${this.my_call_name}は観戦者なので触らんといてください`,
            `暇だったら盤を右クリックして検討しよう`,
          ]
        }
      }
      if (message == null) {
        if (this.order_enable_p && this.current_turn_user_name == null) {
          message = `順番設定で対局者の指定がないので誰も操作できません` // ここにこさせるのはむつかしい
        }
      }
      if (message == null) {
        if (this.i_am_member_p) {
          message = [
            `今は${this.user_call_name(this.current_turn_user_name)}の手番です`,
            `${this.my_call_name}の手番は${this.my_turn_distance_text}です`,
          ]
        }
      }
      return message
    },

    // 自分の手番まであとどれくらいかを表す文字列を返す
    // max_step は「5vs1 3手毎」なら 5x2 * 3 = 30 になる。このあたりは決め打ちで 10 とするのでもよい
    // _.range(a, b + 1) は a..b の意味になる
    my_turn_distance_text() {
      GX.assert(this.i_am_member_p)
      const max_step = this.order_unit.round_size * this.change_per
      const next_step = _.range(1, max_step + 1).find(next_step => {
        return this.turn_to_user_name(this.current_turn + next_step) === this.user_name
      })
      if (next_step == null) {
        return "とうぶん先"
      }
      if (next_step === 1) {
        return "次"
      }
      if (next_step === 2) {
        return "次の次"
      }
      if (next_step === 3) {
        return "次の次の次"
      }
      return `${next_step}手後`
    },
  },
}
