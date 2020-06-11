import consumer from "../channels/consumer"

export default {
  data() {
    return {
      ac_subgscriptions_count: 0,
      ac_subscription_names: [],
    }
  },

  methods: {
    ac_info_update() {
      console.log(this.ac_info())
      this.ac_subscriptions_count = this.ac_subscriptions_count_get()
      this.ac_subscription_names = this.ac_info().map(e => e.channel.replace(/.*::/, "").replace(/channel/i, ""))
    },

    ac_subscriptions_count_get() {
      return consumer.subscriptions["subscriptions"].length
    },

    ac_info() {
      return consumer.subscriptions["subscriptions"].map(e => JSON.parse(e.identifier))
    },

    ac_subscription_create(params, callbacks = {}) {
      return consumer.subscriptions.create(params, {
        connected: () => {
          this.debug_alert("connected")
          this.ac_info_update()
          if (callbacks.connected) {
            callbacks.connected()
          }
        },
        disconnected: () => {
          this.debug_alert("disconnected")
          this.ac_info_update()
          if (callbacks.disconnected) {
            callbacks.disconnected()
          }
        },
        received: (data) => {
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
