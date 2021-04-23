import MemberOrderModal from "./MemberOrderModal.vue"
import { StrictInfo } from "@/components/models/strict_info.js"

export const app_member_order = {
  data() {
    return {
      order_func_p: false,
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
      if (this.ordered_members_blank_p) {
        return null
      }
      // if (this.ordered_members_blank_p) {
      return this.ordered_members_cycle_at(turn).user_name
      // }
    },

    ////////////////////////////////////////////////////////////////////////////////

    order_func_share(params) {
      this.ac_room_perform("order_func_share", params) // --> app/channels/share_board/room_channel.rb
    },
    order_func_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        this.debug_alert("自分→自分")
      } else {
        this.debug_alert("自分→他者")
      }
      this.order_func_p = params.order_func_p
      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が順番設定を${params.message}にしました`)
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

      this.ordered_members = [...params.ordered_members]
      this.strict_key = params.strict_key
      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が順番設定を${params.message}しました`)
      }

      if (false) {
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

    },
  },

  computed: {
    StrictInfo()  { return StrictInfo                                },
    strict_info() { return this.StrictInfo.fetch_if(this.strict_key) },

    // 手番制限
    // 条件 機能ON
    // 条件 共有中のとき
    // 条件 メンバーリストが揃っている
    // 条件 手番制限ON
    // 条件 自分の手番はないとき
    sp_human_side() {
      let retv = "both"
      if (this.order_func_p) {
        if (this.ac_room) {
          // メンバーリストが揃っているなら
          // if (this.ordered_members_blank_p) {
          if (this.turn_strict_on) {
            // 手番制限なら観戦者含めて全体を「禁止」にする
            retv = "none"
            if (this.current_turn_self_p) {
              // そのあとで対象者だけを指せるようにする
              retv = "both"
            }
          }
        }
      }
      return retv
    },

    // private
    ordered_members_blank_p()   { return (this.ordered_members || []).length === 0      }, // メンバーリストが空？
    current_turn_user_name()    { return this.user_name_by_turn(this.turn_offset)       }, // 現在の局面のメンバーの名前
    current_turn_self_p()       { return this.current_turn_user_name === this.user_name }, // 現在自分の手番か？
    turn_strict_on()            { return this.strict_info.key === "turn_strict_on"      }, // 手番制限ON ?
  },
}
