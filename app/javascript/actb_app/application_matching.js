export const application_matching = {
  data() {
    return {
      matching_interval_timer_id: null,
      matching_interval_timer_count: null,
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    matching_setup() {
      this.mode = "matching"

      this.matching_interval_timer_clear()
      this.matching_interval_timer_count = 0
      this.matching_interval_timer_processing()
      this.matching_interval_timer_id = setInterval(this.matching_interval_timer_processing, 1000)
    },

    matching_interval_timer_clear() {
      if (this.matching_interval_timer_id) {
        clearInterval(this.matching_interval_timer_id)
        this.matching_interval_timer_id = null
      }
    },

    matching_interval_timer_processing() {
      if (this.matching_trigger_p) {
        this.matching_search()
      }
      this.matching_interval_timer_count += 1
    },

    matching_search() {
      this.lobby_speak("*matching_search")
      this.$ac_lobby.perform("matching_search", {matching_rate_threshold: this.matching_rate_threshold})
    },
    // マッチング不成立だったりでしょっちゅう呼ばれる
    matching_list_broadcasted(params) {
      this.matching_list_hash = params.matching_list_hash
    },

    room_broadcasted(params) {
      const membership = params.room.memberships.find(e => e.user.id === this.current_user.id)
      if (membership) {
        this.room_setup(params.room)
      }
    },
  },

  computed: {
    matching_trigger_count()  { return Math.floor(this.matching_interval_timer_count / this.app.config.matching_interval_second) },
    matching_trigger_p()      { return (this.matching_interval_timer_count % this.app.config.matching_interval_second) === 0     },
    matching_rate_threshold() { return Math.pow(this.app.config.matching_gap_base, this.app.config.matching_pow_base + this.matching_trigger_count)           },
  },
}
