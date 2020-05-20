const MATCHING_INTERVAL_SECOND = 2
const MATCHING_RATE_THRESHOLD_DEFAULT = 50
const MATCHING_RATE_THRESHOLD_PLUS = 25

export default {
  data() {
    return {
      interval_timer_id: null,
      interval_timer_count: null,
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    matching_init() {
      this.interval_timer_clear()
      this.interval_timer_count = -1
      this.interval_timer_processing()
      this.interval_timer_id = setInterval(this.interval_timer_processing, 1000)
    },

    interval_timer_clear() {
      if (this.interval_timer_id) {
        clearInterval(this.interval_timer_id)
        this.interval_timer_id = null
      }
    },

    interval_timer_processing() {
      if (this.trigger_p) {
        console.log(this.matching_rate_threshold)
        this.matching_start_perform()
      }
      this.interval_timer_count += 1
    },

    matching_start_perform() {
      this.app.$ac_lobby.perform("matching_start", {matching_rate_threshold: this.matching_rate_threshold})
    },
  },

  computed: {
    trigger_count()           { return Math.floor(this.interval_timer_count / MATCHING_INTERVAL_SECOND) },
    trigger_p()               { return (this.interval_timer_count % MATCHING_INTERVAL_SECOND) === 0     },
    matching_rate_threshold() { return Math.pow(2, 5 + this.trigger_count)                              },
  },
}
