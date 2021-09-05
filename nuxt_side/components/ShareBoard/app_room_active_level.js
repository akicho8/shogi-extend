import { IntervalRunner } from '@/components/models/interval_runner.js'

export const app_room_active_level = {
  data() {
    return {
      active_level_increment_timer: new IntervalRunner(this.active_level_increment_timer_callback, {early: false, interval: 1.0}),
      active_level: null, // 部屋の先輩度
    }
  },
  created() {
    this.active_level_init()
  },
  beforeDestroy() {
    if (this.active_level_increment_timer) {
      this.active_level_increment_timer.stop()
    }
  },
  methods: {
    active_level_init() {
      this.active_level = 0
    },

    // 入室中に1秒毎に呼ばれる
    active_level_increment_timer_callback() {
      this.active_level += 1
    },
  },
}
