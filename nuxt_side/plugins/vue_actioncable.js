// https://railsguides.jp/action_cable_overview.html#%E3%82%B3%E3%83%B3%E3%82%B7%E3%83%A5%E3%83%BC%E3%83%9E%E3%83%BC%E3%81%AB%E6%8E%A5%E7%B6%9A%E3%81%99%E3%82%8B
import { createConsumer } from "@rails/actioncable"
const consumer = createConsumer()

export const vue_actioncable = {
  methods: {
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
      }
    },
  },
}
