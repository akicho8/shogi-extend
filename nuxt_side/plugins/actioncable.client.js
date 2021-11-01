import consumer from "../../app/javascript/channels/consumer.js" // FIXME: なんで Rails 側を見ないといけない？

export const vue_actioncable = {
  data() {
    return {
      ac_subgscriptions_count: 0,
      ac_subscription_names: [],
    }
  },

  methods: {
    ac_info_update() {
      console.log("AC有効", this.ac_info().map(e => e.channel).join(" "))

      // FIXME: 全然リアクティブになってない
      this.ac_subscriptions_count = this.ac_subscriptions_count_get()
      this.ac_subscription_names = this.ac_info().map(e => e.channel.replace(/.*::/, "").replace(/channel/i, ""))
      this.$forceUpdate()
    },

    ac_subscriptions_count_get() {
      return consumer.subscriptions["subscriptions"].length
    },

    ac_info() {
      return consumer.subscriptions["subscriptions"].map(e => JSON.parse(e.identifier))
    },

    ac_subscription_create(params, callbacks = {}) {
      console.log(`${params.channel} 接続開始`)

      return consumer.subscriptions.create(params, {
        initialized: e => {
          console.log(`${params.channel} initialized()`)
          if (callbacks.all_hook) {
            callbacks.all_hook("initialized", e)
          }
          if (callbacks.initialized) {
            callbacks.initialized(e)
          }
        },
        connected: e => {
          console.log(`${params.channel} 接続完了`)
          this.debug_alert("connected")
          this.ac_info_update()
          if (callbacks.all_hook) {
            callbacks.all_hook("connected", e)
          }
          if (callbacks.connected) {
            callbacks.connected(e)
          }
        },
        disconnected: e => {
          // 切断したときこのコードはもう存在しないので実行されない？
          console.log(`${params.channel} 切断完了`)
          this.debug_alert("disconnected")
          this.ac_info_update()
          if (callbacks.all_hook) {
            callbacks.all_hook("disconnected", e)
          }
          if (callbacks.disconnected) {
            callbacks.disconnected(e)
          }
        },
        rejected: e => {
          console.log(`${params.channel} 接続失敗`)
          this.debug_alert("rejected")
          this.ac_info_update()
          if (callbacks.all_hook) {
            callbacks.all_hook("rejected", e)
          }
          if (callbacks.rejected) {
            callbacks.rejected(e)
          }
        },
        received: data => {
          if (callbacks.all_hook) {
            callbacks.all_hook("received", data)
          }
          if (callbacks.received) {
            callbacks.received(data)
          }
          if (data.bc_action) {
            this[data.bc_action](data.bc_params)
          }
        },
      })
    },

    ac_unsubscribe(var_name) {
      if (this[var_name]) {
        this[var_name].unsubscribe()
        this[var_name] = null
        this.ac_info_update()
      }
    },
  },
}
