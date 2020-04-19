import consumer from "channels/consumer"

export default {
  methods: {
    ac_subscriptions_count() {
      return consumer.subscriptions["subscriptions"].length
    },

    ac_info() {
      return consumer.subscriptions["subscriptions"].map(e => JSON.parse(e.identifier))
    },
  },
}
