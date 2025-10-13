import { GX } from "@/components/models/gx.js"

export const mod_turn_notify = {
  data() {
    return {
      tn_bell_count: 0,
    }
  },
  methods: {
    tn_bell_call() {
      this.tn_bell_count += 1
      this.debug_alert("(通知効果音)")
      if (false) {
        this.sfx_play_random(["se_moo1", "se_moo2", "se_moo3"])
      } else {
        this.sfx_play("se_notification")
      }
      this.beat_call("long")
    },

    tn_message_build(params) {
      return [
        this.__tn_message_prefix(params),
        this.user_call_name(params.next_user_name),
        "の手番です",
      ].join("")
    },

    // this.change_per                                         // => 2
    // params.lmi.next_turn_offset                             // => 1
    // params.from_user_name                                   // => alice
    // params.next_user_name                                   // => bob
    // this.turn_to_user_name(params.lmi.next_turn_offset - 2) // => dave
    // this.turn_to_user_name(params.lmi.next_turn_offset - 1) // => alice
    // this.turn_to_user_name(params.lmi.next_turn_offset - 0) // => bob
    // this.order_unit.order_state.state_name                  // => O2State
    // this.order_unit.order_state.teams[0].length             // => 2
    // this.order_unit.order_state.teams[1].length             // => 2
    __tn_message_prefix(params) {
      GX.assert(this.order_unit, "this.order_unit")

      if (this.order_unit.order_state.state_name === "O2State") {           // 正確なチーム分けモードなら
        const turn = params.lmi.next_turn_offset
        const location = this.turn_to_location(turn)                        // 渡ってきたこれから指す側のチームを求めて
        if (this.order_unit.order_state.teams[location.code].length >= 2) { // そのチーム内にメンバーが2人以上いる場合は
          const user_name = this.turn_to_user_name(turn - 2)                // 2手前の名前を求めて
          if (params.next_user_name === user_name) {                        // 再度同じ人が指す場合には
            return "次も、"
          }
        }
      } else {
        // O1State の場合は所属チームが曖昧になるため判定ができない
      }

      return "次は、"
    },
  },
  computed: {
    // 次の手番が自分のときに音を成らす条件
    tn_bell_call_p() {
      return this.many_vs_many_p || this.development_p
    },

    // 「次は○○さんの手番です」の発動条件
    tn_name_call_p() {
      return (this.many_vs_many_p || this.development_p) && this.next_turn_call_info.key === "is_next_turn_call_on"
    },
  },
}
