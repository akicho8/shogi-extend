<template lang="pug">
.acns2_sample(:class="mode")
  .columns
    .column
      template(v-if="mode === 'lobby'")
        .buttons.is-centered
          b-button(@click="start_handle" type="is-primary") START

      template(v-if="mode === 'matching_start'")
        b-notification.wait_notification(:closable="false")
          .has-text-centered.has-text-weight-bold
            | 対戦相手を待機中...
            b-loading.is_clickable(:active="true" :is-full-page="false" :can-cancel="true" :on-cancel="cancel_handle")

        template(v-if="development_p")
          .buttons.is-centered
            b-button(@click="cancel_handle" rounded size="is-small") キャンセル

      template(v-if="mode === 'ready_go'")
        p
          | {{room.memberships[0].user.name}} vs {{room.memberships[1].user.name}}

        b-field
          b-input(v-model="message" expanded @keypress.native.enter="speak" autofocus)
          p.control
            button.button.is-primary(@click="speak") 送信
        .box.messages_box(ref="messages_box")
          template(v-for="row in messages")
            div(v-html="row")

      template(v-if="mode === 'room_owari'")
        .has-text-centered
          .is-size-3.has-text-weight-bold
            template(v-if="current_membership.judge_key === 'win'")
              .has-text-danger
                | YOU WIN !!
            template(v-if="current_membership.judge_key === 'lose'")
              .has-text-success
                | YOU LOSE !
        .columns.is-paddingless.is-mobile
          template(v-for="(membership, i) in room.memberships")
            .column.user_continaer.is-flex
              template(v-if="membership.rensho_count >= 2")
                .rensho_count
                  | {{membership.rensho_count}}連勝中！
              figure.image.is-64x64
                img.is-rounded(:src="membership.user.avatar_url")
              .user_name.has-text-weight-bold
                | {{membership.user.name}}
            template(v-if="i === 0")
              .column.vs_mark.is-flex.has-text-weight-bold.is-size-4
                | vs
        .columns.is-mobile
          .column
            .buttons.is-centered
              b-button(@click="lobby_button_handle" type="is-dark")
                | ロビーに戻る

  .columns
    .column
      .box
        div mode={{mode}}
        div matching_set={{matching_set}}
        div current_membership={{current_membership}}

  .columns
    .column
      template(v-show="true")
        table(border=1)
          caption
            | props
          tr(v-for="(value, key) in $props")
            th(v-text="key")
            td(v-text="value")

        table(border=1)
          caption
            | data
          tr(v-for="(value, key) in $data")
            th(v-text="key")
            td(v-text="value")

        table(border=1)
          caption
            | computed
          tr(v-for="(e, key) in _computedWatchers")
            th(v-text="key")
            td(v-text="e.value")
</template>

<script>
import consumer from "channels/consumer"

export default {
  name: "acns2_sample",
  props: {
    info: { required: true },
  },
  data() {
    return {
      mode: this.info.mode,
      room: this.info.room,

      messages: null,
      message: null,
      matching_set: null,
      isLoading: false,

      // private
      $channel: null,
      $lobby: null,
    }
  },

  created() {
    if (this.room) {
    } else {
      this.$lobby = consumer.subscriptions.create({channel: "Acns2::LobbyChannel"}, {
        connected: () => {
          this.debug_alert("connected")
        },
        disconnected: () => {
          this.debug_alert("disconnected")
        },
        received: (data) => {
          this.debug_alert("received")
          console.log(data)

          if (data.matching_set) {
            this.matching_set = data.matching_set
          }

          if (data.room) {
            const membership = data.room.memberships.find(e => e.user.id === this.current_user.id)
            if (membership) {
              this.goto_room(data.room)
            }
          }
        },
      })
    }
  },

  watch: {
    messages() {
      this.scroll_to_bottom()
    },
  },

  methods: {
    speak() {
      this.$channel.perform("speak", {message: this.message})
    },
    scroll_to_bottom() {
      if (this.$refs.messages_box) {
        this.$refs.messages_box.scrollTop = this.$refs.messages_box.scrollHeight
      }
    },
    start_handle() {
      if (!this.current_user) {
        this.self_window_open("/xusers/sign_in")
        return
      }
      this.mode = "matching_start"
      this.isLoading = true
      this.$lobby.perform("matching_start")
    },
    cancel_handle() {
      this.mode = "lobby"
      this.$lobby.perform("matching_cancel")
    },
    goto_room(room) {
      this.room = room
      this.mode = "ready_go"
      this.messages = []
      this.message = String(this.messages.length)

      this.$channel = consumer.subscriptions.create({ channel: "Acns2::RoomChannel", room_id: this.room.id }, {
        connected: () => {
          this.debug_alert("connected")
        },
        disconnected: () => {
          this.debug_alert("disconnected")
        },
        received: (data) => {
          if (data.message) {
            this.messages.push(data.message)
            this.message = String(this.messages.length)
          }
          if (data.mode_change) {
            this.mode = data.mode_change
            this.room = data.room
          }
        },
      })
    },
    lobby_button_handle() {
      this.mode = "lobby"
    },
  },

  computed: {
    current_user() {
      return this.info.current_user
    },
    current_membership() {
      if (this.room) {
        return this.room.memberships.find(e => e.user.id === this.current_user.id)
      }
    }
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.acns2_sample
  // 対戦相手を待機中...
  .wait_notification
    padding: 4rem 0

  .messages_box
    height: 3rem
    overflow-y: scroll
  .user_continaer
    flex-direction: column
    justify-content: flex-end
    align-items: center
    .rensho_count
    figure
      margin-top: 0.5rem
    .user_name
      padding-top: 0.5rem
      font-size: $size-7
  .vs_mark
    flex-direction: column
    justify-content: center
    align-items: center

</style>
