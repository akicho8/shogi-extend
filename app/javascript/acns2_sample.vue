<template lang="pug">
.acns2_sample(:class="mode")
  template(v-if="mode === 'lobby'")
    .columns
      .column
        .title.is-3.has-text-centered 詰将棋ファイター
        .buttons.is-centered
          b-button(@click="start_handle" type="is-primary") START
        .box.is-shadowless.taikityu.has-text-centered.has-background-light(v-if="matching_set && matching_set.length >= 1")
          | {{matching_set.length}}人待機中...

  template(v-if="mode === 'matching_start'")
    b-notification.wait_notification(:closable="false")
      .has-text-centered.has-text-weight-bold
        | 対戦相手を待機中...
      b-loading.is_clickable(:active="true" :is-full-page="false" :can-cancel="true" :on-cancel="cancel_handle")

    template(v-if="development_p")
      .buttons.is-centered
        b-button(@click="cancel_handle" rounded size="is-small") キャンセル

  template(v-if="mode === 'ready_go'")
    .columns.is-centered.is-mobile
      template(v-for="(membership, i) in room.memberships")
        .column.user_continaer.is-flex
          template(v-if="membership.rensho_count >= 2")
            .rensho_count
              | {{membership.rensho_count}}連勝中！
          figure.image.is-32x32
            img.is-rounded(:src="membership.user.avatar_url")
          .user_name.has-text-weight-bold
            | {{membership.user.name}}
          .user_quest_index.has-text-weight-bold.is-size-4
            | {{quest_index_for(membership)}}
        template(v-if="i === 0")
          .column.is-1.vs_mark.is-flex.has-text-weight-bold.is-size-4
            | vs
    .columns(v-if="current_quest_base_sfen")
      .column
        shogi_player(
          :key="`quest_${quest_index}`"
          ref="main_sp"
          :run_mode="'play_mode'"
          :kifu_body="current_quest_base_sfen"
          :summary_show="false"
          :setting_button_show="false"
          :size="'default'"
          :sound_effect="true"
          :volume="0.2"
          :controller_show="true"
          :human_side_key="'both'"
          :theme="'simple'"
          :vlayout="false"
          @update:play_mode_long_sfen="play_mode_long_sfen_set"
        )

    //- .box.is-shadowless.messages_box(ref="messages_box")
    //-   template(v-for="row in messages")
    //-     div(v-html="row")

    .columns.chat_container
      .column
        .messages_box.has-background-light(ref="messages_box")
          template(v-for="row in messages")
            div(v-html="row")
        b-field.input_field
          b-input(v-model="message" expanded @keypress.native.enter="speak")
          p.control
            button.button.is-primary(@click="speak")
              b-icon.play_icon(icon="play")

  template(v-if="mode === 'room_owari'")
    .columns
      .column
        .has-text-centered.is-size-3.has-text-weight-bold
          template(v-if="current_membership.judge_key === 'win'")
            .has-text-danger
              | YOU WIN !
          template(v-if="current_membership.judge_key === 'lose'")
            .has-text-success
              | YOU LOSE !
    .columns.is-mobile
      template(v-for="(membership, i) in room.memberships")
        .column.user_continaer.is-flex
          template(v-if="membership.rensho_count >= 2")
            .icon_up_message.has-text-weight-bold
              | {{membership.rensho_count}}連勝中！
          template(v-if="membership.judge_key === 'lose' && room.final_info.lose_side")
            .icon_up_message.has-text-danger.has-text-weight-bold
              | {{room.final_info.name}}
          figure.image.is-64x64
            img.is-rounded(:src="membership.user.avatar_url")
          .user_name.has-text-weight-bold
            | {{membership.user.name}}
          .user_quest_index.has-text-weight-bold.is-size-4
            | {{quest_index_for(membership)}}
        template(v-if="i === 0")
          .column.vs_mark.is-flex.has-text-weight-bold.is-size-4
            | vs

    .columns.is-mobile
      .column
        .buttons.is-centered
          b-button(@click="lobby_button_handle" type="is-primary")
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
const WAIT_SECOND = 1.5

import consumer from "channels/consumer"

export default {
  name: "acns2_sample",
  props: {
    info: { required: true },
  },
  data() {
    return {
      mode: "lobby",
      room: this.info.room,

      messages: null,
      message: null,
      matching_set: null,
      quest_index: null,        // 解答中の問題インデックス
      freeze_mode: null,        //
      totyu_info: null,

      // private
      $lobby: null, // --> app/channels/acns2/lobby_channel.rb
      $room: null,  // --> app/channels/acns2/room_channel.rb
    }
  },

  created() {
    if (this.info.debug_scene === "ready_go") {
      this.mode = "ready_go"
      this.ready_go_setup()
    }
    if (this.info.debug_scene === "room_owari") {
      this.mode = "room_owari"
    }

    if (this.mode === "lobby") {
      this.lobby_setup()
    }
  },

  watch: {
    messages() {
      this.scroll_to_bottom()
    },
  },

  methods: {
    speak() {
      this.$room.perform("speak", {message: this.message})
    },
    scroll_to_bottom() {
      if (this.$refs.messages_box) {
        this.$nextTick(() => {
          this.$refs.messages_box.scrollTop = this.$refs.messages_box.scrollHeight
        })
      }
    },
    lobby_setup() {
      if (!this.$lobby) {
        this.$lobby = consumer.subscriptions.create({channel: "Acns2::LobbyChannel"}, {
          connected: () => {
            this.debug_alert("lobby connected")
          },
          disconnected: () => {
            this.debug_alert("lobby disconnected")
          },
          received: (data) => {
            this.debug_alert("lobby received")
            console.log(data)

            if (data.matching_set) {
              this.matching_set = data.matching_set
            }

            if (data.room) {
              const membership = data.room.memberships.find(e => e.user.id === this.current_user.id)
              if (membership) {
                this.room = data.room
                this.ready_go_setup()
              }
            }
          },
        })
      }
    },
    start_handle() {
      if (!this.current_user) {
        this.self_window_open("/xusers/sign_in")
        return
      }
      this.sound_play("click")
      this.mode = "matching_start"
      this.$lobby.perform("matching_start")
    },
    cancel_handle() {
      this.sound_play("click")
      this.mode = "lobby"
      this.$lobby.perform("matching_cancel")
    },
    ready_go_setup() {
      this.mode = "ready_go"

      this.messages = []
      this.message = ""
      this.freeze_mode = false
      this.totyu_info = {}

      this.quest_index = 0
      this.sound_play("deden")

      this.$room = consumer.subscriptions.create({ channel: "Acns2::RoomChannel", room_id: this.room.id }, {
        connected: () => {
          this.debug_alert("room connected")
        },
        disconnected: () => {
          this.debug_alert("room disconnected")
        },
        received: (data) => {
          this.debug_alert("room received")

          if (data.message) {
            this.messages.push(data.message)
            this.message = ""
          }

          // 状況を反映する
          if (data.totyu_info_share) {
            const e = data.totyu_info_share
            this.$set(this.totyu_info, e.membership_id, e.quest_index)
            if (e.membership_id !== this.current_membership.id) {
              this.sound_play("pipopipo")
            }
          }

          // 終了
          if (data.room_owari) {
            this.mode = "room_owari"
            this.room = data.room
            if (this.current_membership) {
              if (this.current_membership.judge_key === "win") {
                this.sound_play("win")
              }
              if (this.current_membership.judge_key === "lose") {
                this.sound_play("lose")
              }
            }
          }
        },
      })
    },
    lobby_button_handle() {
      this.sound_play("click")
      this.mode = "lobby"
      this.lobby_setup()
    },

    play_mode_long_sfen_set(long_sfen) {
      if (this.freeze_mode) {
        return
      }

      if (this.current_quest_answers.includes(long_sfen)) {
        this.sound_play("pipopipo")
        this.$room.perform("totyu_info_share", {membership_id: this.current_membership.id, quest_index: this.quest_index + 1}) // --> app/channels/acns2/room_channel.rb

        this.freeze_mode = true
        setTimeout(() => {
          this.quest_index += 1
          if (this.quest_index >= this.current_simple_quest_info_size) {
            this.$room.perform("katimasitayo") // --> app/channels/acns2/room_channel.rb
          } else {
            this.sound_play("deden")
            this.freeze_mode = false
          }
        }, 1000 * WAIT_SECOND)

      }
      // if (long_sfen === "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 moves G*5b") {
      //   this.$room.perform("katimasitayo") // --> app/channels/acns2/room_channel.rb
      // }
    },

    quest_index_for(membership) {
      if (this.totyu_info) {
        return this.totyu_info[membership.id] || 0
      }
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
    },
    current_simple_quest_info() {
      if (this.room) {
        return this.room.simple_quest_infos[this.quest_index]
      }
    },
    current_simple_quest_info_size() {
      if (this.room) {
        return this.room.simple_quest_infos.length
      }
    },
    current_quest_base_sfen() {
      const info = this.current_simple_quest_info
      if (info) {
        return info.base_sfen
      }
    },
    current_quest_answers() {
      const info = this.current_simple_quest_info
      if (info) {
        return info.seq_answers.map(e => [info.base_sfen, "moves", e].join(" "))
      }
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.acns2_sample
  // lobby_mode
  .taikityu
    margin-top: 0.8rem

  // 対戦相手を待機中...
  .wait_notification
    padding: 4rem 0

  .chat_container
    .messages_box
      padding: 0.5rem
      height: 10em
      overflow-y: scroll
    .input_field
      margin-top: 0.5rem
      .play_icon
        min-width: 3rem

  .user_continaer
    flex-direction: column
    justify-content: flex-end
    align-items: center

    // アイコンの上の勝敗メッセージ
    .icon_up_message

    // アイコン
    figure
      margin-top: 0.5rem

    // ユーザー名
    .user_name
      padding-top: 0.5rem
      font-size: $size-7

  .vs_mark
    flex-direction: column
    justify-content: center
    align-items: center

</style>
