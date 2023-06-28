export const mod_turn_notify = {
  data() {
    return {
      tn_counter: 0,
    }
  },
  methods: {
    tn_notify() {
      this.tn_counter += 1
      this.debug_alert("(通知効果音)")
      this.$sound.play("notification")
      this.$beat.call_long()
    },
  },
  computed: {
    // tn_notify を呼ぶ条件
    // 「牛」と「次は○○」の発動条件
    next_notify_p() {
      return (this.many_vs_many_p || this.development_p) && this.next_turn_call_info.key === "is_next_turn_call_on"
    },
  },
}
