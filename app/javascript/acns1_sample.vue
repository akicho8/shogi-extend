<template lang="pug">
.acns1_sample
  .columns
    .column
      b-field
        b-input(v-model="message" expanded @keypress.native.enter="speak" autofocus)
        p.control
          button.button.is-primary(@click="speak") 送信
      .box.messages_box(ref="messages_box")
        template(v-for="row in messages")
          div(v-html="row")
</template>

<script>
import consumer from "channels/consumer"

export default {
  name: "acns1_sample",
  props: {
    info: { required: true },
  },
  data() {
    return {
      messages: null,
      message: null,

      // private
      $channel: null,
    }
  },

  created() {
    this.messages = this.info.messages
    this.message = this.messages.length

    this.$channel = consumer.subscriptions.create({ channel: "Acns1::RoomChannel", room_id: this.info.room.id }, {
      connected: () => {
        this.debug_alert("connected")
      },
      disconnected: () => {
        this.debug_alert("disconnected")
      },
      received: (data) => {
        this.messages.push(data["message"])
        this.message = this.messages.length
      },
    })
  },

  watch: {
    messages() {
      this.scroll_to_bottom(this.$refs.messages_box)
    },
  },

  methods: {
    speak() {
      this.$channel.perform("speak", {message: this.message})
    },
  },
}
</script>

<style lang="sass">
.acns1_sample
  .messages_box
    height: 20rem
    overflow-y: scroll
</style>
