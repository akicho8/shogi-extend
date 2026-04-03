import { IntervalRunner } from '@/components/models/interval_runner.js'

export const mod_room_active_level = {
  data() {
    return {
      active_level: null, // 部屋の先輩度
    }
  },
  created() {
    this.active_level_init()
    this.active_level_increment_timer_create()
  },
  beforeDestroy() {
    this.active_level_increment_timer_destroy()
  },
  methods: {
    // public

    active_level_increment_timer_stop() {
      if (this.active_level_increment_timer) {
        this.active_level_increment_timer.stop()
      }
    },

    active_level_increment_timer_restart() {
      if (this.active_level_increment_timer) {
        this.active_level_increment_timer.restart()
      }
    },

    // private

    active_level_init() {
      this.active_level = 0
    },

    // 入室中に1秒毎に呼ぶ
    active_level_increment_timer_callback() {
      this.active_level += 1
    },

    active_level_increment_timer_create() {
      this.tl_p("--> active_level_increment_timer_create")
      if (!this.active_level_increment_timer) {
        this.active_level_increment_timer = new IntervalRunner(this.active_level_increment_timer_callback, {
          name: "先輩度更新",
          debug: false,
          early: false,
          interval: 1.0,
        })
      }
      this.tl_p("<-- active_level_increment_timer_create")
    },

    active_level_increment_timer_destroy() {
      if (this.active_level_increment_timer) {
        this.active_level_increment_timer_stop()
        this.active_level_increment_timer = null
      }
    },

  },
}
