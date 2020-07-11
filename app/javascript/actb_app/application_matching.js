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
      this.matching_interval_timer_processing() // 初回は待つ必要がないのですぐに呼ぶ
      this.matching_interval_timer_id = setInterval(this.matching_interval_timer_processing, 1000)
    },

    matching_interval_timer_clear() {
      if (this.matching_interval_timer_id) {
        clearInterval(this.matching_interval_timer_id)
        this.matching_interval_timer_id = null
      }
    },

    matching_interval_timer_processing() {
      if (this.matching_forgo_p) {
        this.matching_cancel_handle()
        this.warning_notice("対戦相手が見つかりません")
        return
      }
      if (this.matching_trigger_p) {
        this.matching_search()
      }
      this.matching_interval_timer_count += 1
    },

    matching_search() {
      this.$ac_lobby.perform("matching_search", {matching_rate_threshold: this.matching_rate_threshold})
    },
    // マッチング不成立だったりでしょっちゅう呼ばれる
    matching_user_ids_broadcasted(params) {
      this.matching_user_ids_hash = params.matching_user_ids_hash
      if (params.trigger === "add") {
        if (params.user_id === this.current_user.id) {
          // 自分が開始したので自分に通知しても意味がない
        } else {
          this.sound_play("bell1")
          this.ok_notice("対戦者が待っています")
        }
      }
    },

    room_broadcasted(params) {
      const membership = params.room.memberships.find(e => e.user.id === this.current_user.id)
      if (membership) {
        this.room_setup(params.room)
      }
    },
  },

  computed: {
    matching_trigger_count()  { return Math.floor(this.matching_interval_timer_count / this.app.config.matching_interval_second)                                   },
    matching_trigger_p()      { return (this.matching_interval_timer_count % this.app.config.matching_interval_second) === 0                                       },
    matching_rate_threshold() { return Math.round(Math.pow(this.app.config.matching_gap_base, this.app.config.matching_pow_base + this.matching_trigger_count))    },
    matching_forgo_p()        { return this.app.config.matching_forgo_second && (this.matching_interval_timer_count >= this.app.config.matching_forgo_second) },
  },
}
