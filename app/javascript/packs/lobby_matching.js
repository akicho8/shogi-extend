import _ from "lodash"

export default {
  data() {
    return {
      matching_at:          null,
      matching_counter:     null,
      matching_interval_id: null,
      matching_counter_trigger: 2,
    }
  },

  created() {
    if (this.current_user) {
      console.assert("matching_at" in this.current_user)
      this.matching_wait(this.current_user.matching_at)
    }
  },

  methods: {
    matching_start() {
      App.lobby.matching_start({})
    },

    matching_cancel() {
      this.matching_at = null
      this.matching_clear_interval()
      App.lobby.matching_cancel()
    },

    matching_wait(time) {
      this.matching_at = time
      if (this.matching_at) {
        this.matching_counter = 1
        this.matching_clear_interval()
        this.matching_interval_id = setInterval(() => {
          this.matching_counter++
          if (this.robot_accept_key === "accept") {
            if (this.matching_counter === this.matching_counter_trigger) {
              Vue.prototype.$dialog.confirm({
                title: "確認",
                message: "相手がいないのでCPUと対局しますか？",
                confirmText: "はい",
                cancelText: "いいえ",
                onConfirm: () => {
                  App.lobby.matching_start_with_robot()
                },
              })
            }
          }
        }, 1000)
      }
    },

    matching_clear_interval() {
      if (!_.isNil(this.matching_interval_id)) {
        clearInterval(this.matching_interval_id)
        this.matching_interval_id = null
      }
    },
  },
}
