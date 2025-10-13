import { IntervalCounter } from '@/components/models/interval_counter.js'
import { GX } from "@/components/models/gs.js"

export const mod_sound_bug = {
  data() {
    return {
      sb_counter: null,
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
      if (this.sb_counter == null) {
        this.sb_counter = new IntervalCounter(this.sound_bug_callback, {interval: 1})
      }
      this.sb_counter.start()
    },
    sound_bug_stop() {
      if (this.sb_counter) {
        this.sb_counter.stop()
      }
    },
    sound_bug_callback(counter) {
      this.sb_talk(`${counter}.${GX.irand(99999)}`)
    },
  },
}
