import consumer from "channels/consumer"

export default {
  data() {
    return {
      ac_subscriptions_count: null,
    }
  },

  methods: {
    ac_info_update() {
      console.log(this.ac_info())
      this.ac_subscriptions_count = this.ac_subscriptions_count_get()
    },

    ac_subscriptions_count_get() {
      return consumer.subscriptions["subscriptions"].length
    },

    ac_info() {
      return consumer.subscriptions["subscriptions"].map(e => JSON.parse(e.identifier))
    },
  },
}
