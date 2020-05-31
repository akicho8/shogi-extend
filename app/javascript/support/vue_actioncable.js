import consumer from "channels/consumer"

export default {
  data() {
    return {
      ac_subscriptions_count: 0,
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
          this.ac_info_update()
          if (this.callbacks.connected) {
            this.callbacks.connected()
          }
        },
        disconnected: () => {
          this.ac_info_update()
          if (this.callbacks.disconnected) {
            this.callbacks.disconnected()
          }
        },
        received: (data) => {
          if (data.bc_action) {
            this[data.bc_action](data.bc_params)
          }
        },
      })
    },
  },
}
