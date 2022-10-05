export const app_turn_notify = {
  data() {
    return {
      tn_counter: 0,
    }
  },
  methods: {
    tn_notify() {
      this.tn_counter += 1
      this.debug_alert("(通知効果音)")
      this.sound_play("notification")
      // this.sound_moo()
      this.vibrate_long()
    },
    sound_moo() {
      this.sound_play_random(["moo1", "moo2", "moo3"])
    },
  },
  computed: {
    // tn_notify を呼ぶ条件
    // 「牛」と「次は○○」の発動条件
    next_notify_p() { return this.many_vs_many_p || this.development_p },
  },
}
