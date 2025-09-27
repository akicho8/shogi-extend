export const mod_mode = {
  data() {
    return {
      mode: null,
    }
  },

  methods: {
    mode_set(v) {
      this.mode = v
    },

    quit_handle() {
      if (this.is_running_p) {
        this.sfx_stop_all()
        this.talk("途中で辞めました")
        this.sfx_play_click()
        this.mode_set("standby")
        this.re_ox_stop()
      }
    },

    close_handle() {
      this.sfx_play_click()
      this.mode_set("standby")
    },
  },

  computed: {
    is_standby_p() { return this.mode === "standby" },
    is_running_p() { return this.mode === "running" },
    is_goal_p()    { return this.mode === "goal"    },
  },
}
