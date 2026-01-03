import { IntervalCounter } from '@/components/models/interval_counter.js'
import { GX } from "@/components/models/gx.js"

export const howler_bug_reproduce = {
  data() {
    return {
      sound_bug_counter: null,
    }
  },
  mounted() {
    // if (this.$route.query.sound_bug_behaviour === "chat_simulate") {
    //   this.sound_bug_start()
    // }
  },
  beforeDestroy() {
    this.sound_bug_stop()
  },
  methods: {
    sound_bug_start() {
      if (this.sound_bug_counter == null) {
        this.sound_bug_counter = new IntervalCounter(this.sound_bug_callback, {interval: 1})
      }
      this.sound_bug_counter.start()
    },
    sound_bug_stop() {
      if (this.sound_bug_counter) {
        this.sound_bug_counter.stop()
      }
    },
    sound_bug_callback(counter) {
      this.sb_talk(`${counter}.${GX.irand(99999)}`)
    },
  },
}
