import { IntervalCounter } from '@/components/models/interval_counter.js'

export const app_interval_counter = {
  data() {
    return {
      interval_counter: null,
    }
  },
  beforeMount() {
    this.interval_counter_init()
  },
  beforeDestroy() {
    this.interval_counter_destroy()
  },
  methods: {
    interval_counter_init() {
      this.interval_counter = new IntervalCounter(() => this.interval_counter_callback())
    },
    interval_counter_callback() {
      if (this.interval_counter_countable_p) {
        this.current_spent_sec += 1
      }
    },
    interval_counter_pause(v) {
      // if (this.is_running_p) {
      //   if (v) {
      //     this.interval_counter.stop()
      //   } else {
      //     this.interval_counter.start()
      //   }
      // }
    },
    interval_counter_destroy() {
      if (this.interval_counter) {
        this.interval_counter.stop()
        this.interval_counter = null
      }
    },
  },
  computed: {
    interval_counter_countable_p() {
      return this.is_running_p && !this.sidebar_p && !this.kb_shortcut_modal_p
    },
  },
}
