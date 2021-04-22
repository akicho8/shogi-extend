import MemberOrderModal from "./MemberOrderModal.vue"
import { StrictInfo } from "@/components/models/strict_info.js"

export const app_member_order = {
  data() {
    return {
      ordered_members: null, // 出走順の配列
      strict_key: "turn_strict_on",
    }
  },
  methods: {
    mo_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: MemberOrderModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => { this.sound_play("click") },
        props: {
          base: this.base,
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    ordered_members_cycle_at(index) {
      return this.ary_cycle_at(this.ordered_members, index)
    },

    // 局面 turn の手番のメンバーの名前
    user_name_by_turn(turn) {
      if (this.ordered_members && this.ordered_members.length >= 1) {
        return this.ordered_members_cycle_at(turn).user_name
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    ordered_members_share(params) {
      this.ac_room_perform("ordered_members_share", params) // --> app/channels/share_board/room_channel.rb
    },
    ordered_members_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        this.debug_alert("自分→自分")
      } else {
        this.debug_alert("自分→他者")
      }

      if (true) {
        this.ordered_members = [...params.ordered_members]
        const member = this.ordered_members.find(e => e.user_name === this.user_name)
        if (member) {
          const previous_index = this.ruby_like_modulo(member.order_index - 1, this.ordered_members.length)
          const ordered_member = this.ordered_members[previous_index]
          this.previous_user_name = ordered_member.user_name
          this.toast_ok(`${this.user_call_name(params.from_user_name)}が${this.user_call_name(this.user_name)}の手番の通知を有効にしました`)
        } else {
          this.previous_user_name = null
          this.toast_ok(`${this.user_call_name(params.from_user_name)}が${this.user_call_name(this.user_name)}の手番の通知を無効にしました`)
        }
      }

      this.strict_key = params.strict_key
    },
  },

  computed: {
    StrictInfo()  { return StrictInfo                                },
    strict_info() { return this.StrictInfo.fetch_if(this.strict_key) },

    current_turn_user_name() { return this.user_name_by_turn(this.turn_offset)        }, // 現在の局面のメンバーの名前
    current_turn_self_p()    { return this.current_turn_user_name === this.user_name  }, // 現在自分の手番か？

    // 手番制限
    // 条件1. 共有中のとき
    // 条件2. 手番制限をしたいとき
    // 条件3. 自分の手番はないとき
    sp_human_side() {
      let retv = "both"
      if (this.ac_room) {
        if (this.strict_info.key === StrictInfo.fetch("turn_strict_on").key) {
          if (!this.current_turn_self_p) {
            retv = "none"
          }
        }
      }
      return retv
    }

    // my_ordered_member() {
    //   return this.ordered_members.find(e => e.user_name === this.user_name)
    // },

    // const previous_index = this.ruby_like_modulo(member.order_index - 1, this.ordered_members.length)
    //       const ordered_member = this.ordered_members[previous_index]
    //       this.previous_user_name = ordered_member.user_name
    //       this.toast_ok(`${this.user_call_name(params.from_user_name)}が${this.user_call_name(this.user_name)}の手番の通知を有効にしました`)

    // jibun_index() {
    //   this.turn_offset
    //
    // },

  },
}
