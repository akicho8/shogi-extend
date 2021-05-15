export const app_persistent_cc_params = {
  methods: {
    cc_params_load() {
      this.tl_add("CC初期値", `LOAD: ${JSON.stringify(this.cc_params_values(this.persistent_cc_params))}`)
      this.cc_params = {...this.persistent_cc_params}
    },

    cc_params_save() {
      this.tl_add("CC初期値", `SAVE: ${JSON.stringify(this.cc_params_values(this.cc_params))}`)
      this.persistent_cc_params = {...this.cc_params}
    },

    cc_params_reset() {
      this.tl_add("CC初期値", `RESET: ${JSON.stringify(this.cc_params_values(this.default_persistent_cc_params))}`)
      this.persistent_cc_params = {...this.default_persistent_cc_params}
    },

    // private

    cc_params_values(params) {
      return this.cc_params_keys.map(e => params[e])
    },
  },
  computed: {
    cc_params_keys() {
      return Object.keys(this.default_persistent_cc_params)
    },

    default_persistent_cc_params() {
      return {
        initial_main_min:   0, // 持ち時間(分)
        initial_read_sec:  30, // 秒読み
        initial_extra_sec: 30, // 猶予(秒)
        every_plus:         0, // 1手毎加算
      }
    },
  },
}
