<template lang="pug">
.acns3_sample(:class="mode")
  .columns
    .column
      .main_info.is-flex
        p
          | 購読数: {{ac_subscriptions_count}}
        p(v-if="online_user_ids != null")
          | オンライン: {{online_user_ids.length}}人
        p(v-if="room_user_ids != null")
          | 対戦中: {{room_user_ids.length}}人
        p(v-if="matching_list != null")
          | 対戦待ち: {{matching_list.length}}人

  template(v-if="mode === 'lobby'")
    .columns
      .column
        .title.is-3.has-text-centered 詰将棋ファイター
        .buttons.is-centered
          b-button.has-text-weight-bold(@click="start_handle" type="is-primary") START
        .buttons.is-centered
          b-button.has-text-weight-bold(@click="goto_edit_mode_handle") 投稿

  template(v-if="mode === 'matching_start'")
    acns3_sample_matching_start(:info="info")

  template(v-if="mode === 'ready_go'")
    .columns.is-centered.is-mobile
      template(v-for="(membership, i) in room.memberships")
        .column.user_container.is-flex
          template(v-if="membership.rensho_count >= 2")
            .rensho_count
              | {{membership.rensho_count}}連勝中！
          figure.image.is-32x32
            img.is-rounded(:src="membership.user.avatar_path")
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
          :setting_button_show="development_p"
          :size="'default'"
          :sound_effect="true"
          :volume="0.5"
          :controller_show="true"
          :human_side_key="'both'"
          :theme="'simple'"
          :vlayout="false"
          @update:play_mode_advanced_full_moves_sfen="play_mode_advanced_full_moves_sfen_set"
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

  template(v-if="mode === 'result_show'")
    .columns.is-mobile.result_container
      .column
        .has-text-centered.is-size-3.has-text-weight-bold
          template(v-if="current_membership.judge_key === 'win'")
            .has-text-danger
              | YOU WIN !
          template(v-if="current_membership.judge_key === 'lose'")
            .has-text-success
              | YOU LOSE !
    .columns.is-mobile.result_container
      template(v-for="(membership, i) in room.memberships")
        .column.user_container.is-flex
          template(v-if="membership.rensho_count >= 2")
            .icon_up_message.has-text-weight-bold
              | {{membership.rensho_count}}連勝中！
          template(v-if="membership.judge_key === 'lose' && room.final_info.lose_side")
            .icon_up_message.has-text-danger.has-text-weight-bold
              | {{room.final_info.name}}
          figure.image.is-64x64
            img.is-rounded(:src="membership.user.avatar_path")
          .user_name.has-text-weight-bold
            | {{membership.user.name}}
          .user_quest_index.has-text-weight-bold.is-size-4
            | {{membership.quest_index}}
          .user_rating.has-text-weight-bold
            | {{membership.user.acns3_profile.rating}}
            span.user_rating_diff
              template(v-if="membership.user.acns3_profile.rating_last_diff >= 0")
                span.has-text-primary
                  | (+{{membership.user.acns3_profile.rating_last_diff}})
              template(v-if="membership.user.acns3_profile.rating_last_diff < 0")
                span.has-text-danger
                  | ({{membership.user.acns3_profile.rating_last_diff}})
        template(v-if="i === 0")
          .column.is-1.vs_mark.is-flex.has-text-weight-bold.is-size-4
            | vs

    .columns.is-mobile
      .column
        .buttons.is-centered
          b-button.has-text-weight-bold(@click="lobby_button_handle" type="is-primary")
            | ロビーに戻る

  template(v-if="mode === 'edit'")
    acns3_sample_editor(:info="info")

  debug_print

  dump(:data="info" label="info")
</template>

<script>
const WAIT_SECOND = 1.5

import consumer from "channels/consumer"

import acns3_sample_support from './acns3_sample_support.js'
import acns3_sample_matching_start from './acns3_sample_matching_start.vue'
import acns3_sample_editor from './acns3_sample_editor.vue'

export default {
  name: "acns3_sample",
  mixins: [
    acns3_sample_support,
  ],
  components: {
    acns3_sample_editor,
    acns3_sample_matching_start,
  },
  props: {
    info: { required: true },
  },
  data() {
    return {
      mode: "lobby",
      room: this.info.room,

      matching_list: null,   // 対戦待ちの人のIDを列挙している
      online_user_ids: null, // オンライン人数
      room_user_ids: null,   // オンライン人数
      quest_index: null,     // 正解中の問題インデックス
      freeze_mode: null,     // 正解直後に間を開けているとき true になっている
      progress_info: null,   // 各 membership_id はどこまで進んでいるかわかる {"1" => 2, "3" => 4}

      // チャット用
      messages: null,           // メッセージ(複数)
      message: null,            // 入力中のメッセージ

      // private
      $school: null,        // --> app/channels/acns3/school_channel.rb
      $lobby: null,         // --> app/channels/acns3/lobby_channel.rb
      $room: null,          // --> app/channels/acns3/room_channel.rb

      // editモード index
      questions: null,

      // editモード edit
      sp_run_mode: null,
      edit_tab_index: null,
      // provisional_sfen: null,
      question: null,
      time_limit_clock: null,   // b-timepicker 用 (question.time_limit_sec から変換する)
      answer_tab_index: null,   // 表示している正解タブの位置

      // pagination 5点セット
      total:              this.info.total,
      page:               this.info.page,
      per:                this.info.per,
      sort_column:        this.info.sort_column,
      sort_order:         this.info.sort_order,
      sort_order_default: this.info.sort_order_default,

      answer_turn_offset: null, // 正解モードでの手数
      $exam_run_count: null,    // 試験モードで手を動かした数
    }
  },

  created() {
    this.school_setup()

    if (this.info.debug_scene === "ready_go") {
      this.mode = "ready_go"
      this.room_setup()
    }
    if (this.info.debug_scene === "result_show") {
      this.mode = "result_show"
    }
    if (this.info.debug_scene === "edit") {
      this.goto_edit_mode_handle()
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
    ////////////////////////////////////////////////////////////////////////////////

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

    school_setup() {
      this.$school = consumer.subscriptions.create({channel: "Acns3::SchoolChannel"}, {
        connected: () => {
          this.debug_alert("school 接続")
        },
        disconnected: () => {
          this.debug_alert("school 切断")
        },
        received: (data) => {
          if (data.online_user_ids) {
            this.online_user_ids = data.online_user_ids
          }
          if (data.room_user_ids) {
            this.room_user_ids = data.room_user_ids
          }
          this.ac_info_update()
        },
      })
    },

    lobby_setup() {
      this.debug_alert("lobby_setup")
      this.__assert(this.$lobby == null)
      this.$lobby = consumer.subscriptions.create({channel: "Acns3::LobbyChannel"}, {
        connected: () => {
          this.debug_alert("lobby 接続")
        },
        disconnected: () => {
          this.debug_alert("lobby 切断")
        },
        received: (data) => {
          this.debug_alert("lobby 受信")

          // マッチング待ち
          if (data.matching_list) {
            console.log(data.matching_list)
            this.matching_list = data.matching_list
          }

          // マッチング成立
          if (data.room) {
            const membership = data.room.memberships.find(e => e.user.id === this.current_user.id)
            if (membership) {
              this.lobby_unsubscribe()
              this.interval_timer_clear()

              this.room = data.room
              this.room_setup()
            }
          }
        },
      })
    },

    start_handle() {
      if (this.login_required2()) { return }

      this.sound_play("click")
      this.mode = "matching_start"
    },

    cancel_handle() {
      this.sound_play("click")
      this.mode = "lobby"
      this.$lobby.perform("matching_cancel")
    },

    room_setup() {
      this.mode = "ready_go"

      this.messages = []
      this.message = ""

      this.freeze_mode = false
      this.progress_info = {}

      this.quest_index = 0
      this.sound_play("deden")

      this.__assert(this.$room == null)
      this.$room = consumer.subscriptions.create({ channel: "Acns3::RoomChannel", room_id: this.room.id }, {
        connected: () => {
          this.debug_alert("room 接続")
        },
        disconnected: () => {
          alert("room disconnected")
          this.debug_alert("room 切断")
        },
        received: (data) => {
          this.debug_alert("room 受信")

          // チャット
          if (data.message) {
            this.messages.push(data.message)
            this.message = ""
          }

          // 状況を反映する (なるべく小さなデータで共有する)
          if (data.progress_info_share) {
            const e = data.progress_info_share
            this.$set(this.progress_info, e.membership_id, e.quest_index)
            if (e.membership_id !== this.current_membership.id) {
              this.sound_play("pipopipo")
            }
          }

          // 終了
          if (data.switch_to === "result_show") {
            this.mode = "result_show"
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

      this.room_unsubscribe()

      this.mode = "lobby"
      this.lobby_setup()
    },

    play_mode_advanced_full_moves_sfen_set(long_sfen) {
      if (this.freeze_mode) {
        return
      }

      if (this.current_quest_answers.includes(long_sfen)) {
        this.sound_play("pipopipo")
        this.$room.perform("progress_info_share", {membership_id: this.current_membership.id, quest_index: this.quest_index + 1}) // --> app/channels/acns3/room_channel.rb

        this.freeze_mode = true
        setTimeout(() => {
          this.quest_index += 1
          if (this.quest_index >= this.current_simple_quest_info_size) {
            this.$room.perform("katimasitayo") // --> app/channels/acns3/room_channel.rb
          } else {
            this.sound_play("deden")
            this.freeze_mode = false
          }
        }, 1000 * WAIT_SECOND)

      }
      // if (long_sfen === "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 moves G*5b") {
      //   this.$room.perform("katimasitayo") // --> app/channels/acns3/room_channel.rb
      // }
    },

    quest_index_for(membership) {
      if (this.progress_info) {
        return this.progress_info[membership.id] || 0
      }
    },

    login_required2() {
      if (!this.current_user) {
        this.url_open(this.login_path)
        return true
        // this.url_open("/xusers/sign_in")
      }
    },

    lobby_unsubscribe() {
      if (this.$lobby) {
        this.$lobby.unsubscribe()
        this.$lobby = null
        this.ac_info_update()
      }
    },

    room_unsubscribe() {
      if (this.$room) {
        this.$room.unsubscribe()
        this.$room = null
        this.ac_info_update()
      }
    },

    goto_edit_mode_handle() {
      this.sound_play("click")

      this.lobby_unsubscribe()

      this.mode = "edit"
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

    // いったんスクリプトに飛ばしているのは sessions[:return_to] を設定するため
    login_path() {
      const url = new URL(location)
      url.searchParams.set("login_required", true)
      return url.toString()
    },

  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.acns3_sample
  .main_info
    justify-content: space-between

  // lobby_mode

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

  // ユーザー情報
  .user_container
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
      margin-top: 0.5rem
      font-size: $size-7

    .user_rating_diff
      margin-left: 0.25rem

  // リザルト
  .result_container
    .vs_mark
      flex-direction: column
      justify-content: center
      align-items: center
</style>
