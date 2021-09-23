import { IntervalRunner } from '@/components/models/interval_runner.js'

const INTERVAL = 60 * 10 // 10分毎に監視 ../../../app/models/lemon.rb

export const app_zombie_kill = {
  data() {
    return {
      zombie_kill_timer: new IntervalRunner(this.zombie_kill_timer_callback, {name: "zombie_kill_timer", early: false, interval: INTERVAL}),
    }
  },

  mounted() {
    this.zombie_kill_timer.restart()
  },

  beforeDestroy() {
    this.zombie_kill_timer.stop()
  },

  methods: {
    zombie_kill_timer_callback() {
      // ../../../app/controllers/api/kiwi/lemons_controller.rb
      this.$axios.$post("/api/kiwi/lemons/zombie_kill.json", {}).then(e => {
        this.debug_alert(`zombie_kill: ${e.status}`)
      })
    },
  },
}
