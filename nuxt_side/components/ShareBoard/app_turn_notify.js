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
      this.sound_moo()
      this.vibrate(100)
    },
    sound_moo() {
      this.sound_play_random(["moo1", "moo2", "moo3"])
    },
  },
  computed: {
    next_notify_p() { return this.development_p || this.many_vs_many_p }, // 「牛」と「次は○○」の発動条件
  },
}
