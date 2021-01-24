export const app_mode = {
  data() {
    return {
      mode: null,
    }
  },

  methods: {
    mode_set(v) {
      this.mode = v
    }
  },

  computed: {
    is_standby_p() { return this.mode === "standby" },
    is_running_p() { return this.mode === "running" },
    is_goal_p()    { return this.mode === "goal"    },
  },
}
