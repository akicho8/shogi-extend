import MemberOrderModal from "./MemberOrderModal.vue"

export const app_member_order = {
  data() {
    return {
      ordered_members: null, // 上家の名前
    }
  },
  methods: {
    mo_notify() {
      // this.sound_play_random(["moo1", "moo2", "moo3"])
      // this.debug_alert("あなたの手番です")
    },

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

    ordered_members_share(real_order_members) {
      const params = {}
      params.ordered_members = real_order_members
      this.ac_room_perform("ordered_members_share", params) // --> app/channels/share_board/room_channel.rb
    },
    ordered_members_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        // 自分→自分
      } else {
        // 自分→他者
      }

      this.ordered_members = [...params.ordered_members]

      const index = this.ordered_members.findIndex(e => e.user_name === this.user_name)
      console.log(index)
      if (index >= 0) {
        const previous_index = this.ruby_like_modulo(index - 1, this.ordered_members.length)
        const ordered_member = this.ordered_members[previous_index]
        this.previous_user_name = ordered_member.user_name
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が${this.user_call_name(this.user_name)}の手番の通知を有効にしました`)
      } else {
        this.previous_user_name = null
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が${this.user_call_name(this.user_name)}の手番の通知を無効にしました`)
      }
    },
  },
}
