<template lang="pug">
.acns2_sample(:class="mode")
  .columns
    .column
      .main_info.is-flex
        p
          | 購読数: {{ac_subscriptions_count()}}
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
    .columns.is-paddingless
      .column
        .has-text-centered.has-text-weight-bold
          | 対戦相手を待機中
        b-progress(type="is-primary")
        .buttons.is-centered
          button.delete.is-large(@click="cancel_handle")

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
            | {{membership.user.acns2_profile.rating}}
            span.user_rating_diff
              template(v-if="membership.user.acns2_profile.rating_last_diff >= 0")
                span.has-text-primary
                  | (+{{membership.user.acns2_profile.rating_last_diff}})
              template(v-if="membership.user.acns2_profile.rating_last_diff < 0")
                span.has-text-danger
                  | ({{membership.user.acns2_profile.rating_last_diff}})
        template(v-if="i === 0")
          .column.is-1.vs_mark.is-flex.has-text-weight-bold.is-size-4
            | vs

    .columns.is-mobile
      .column
        .buttons.is-centered
          b-button.has-text-weight-bold(@click="lobby_button_handle" type="is-primary")
            | ロビーに戻る

  template(v-if="mode === 'edit'")
    .columns.is-centered
      .column
        .buttons
          b-button.has-text-weight-bold(@click="jump_to_index_handle") 問題一覧
          b-button.has-text-weight-bold(@click="jump_to_new_handle") 新規作成

        template(v-if="!question")
          //- :columns="candidate_columns"
          b-table(
            v-if="questions"
            :data="questions"
            mobile-cards
            hoverable
            narrowed

            paginated
            backend-pagination
            pagination-simple
            :current-page="page"
            :total="total"
            :per-page="per"
            @page-change="page_change_handle"

            backend-sorting
            :default-sort-direction="sort_order_default"
            :default-sort="[sort_column, sort_order]"
            @sort="sort_handle"
          )
            template(slot-scope="props")
              b-table-column(field="id" label="ID" sortable) {{props.row.id}}
              b-table-column(field="title" label="タイトル" sortable) {{props.row.title || '？'}}
              b-table-column(field="difficulty_level" label="難易度" sortable) {{props.row.difficulty_level}}
              b-table-column(field="moves_answers_count" label="解答数" sortable) {{props.row.moves_answers.length}}
              b-table-column(field="updated_at" label="更新日時" sortable) {{row_time_format(props.row.updated_at)}}
              b-table-column(label="操作")
                a(@click="question_edit_of(props.row)") 編集

        template(v-if="question")
          //- b-field.switch_grouped_container(grouped position="is-centered")
          //-   .control
          //-     b-switch(v-model="sp_run_mode" true-value="edit_mode" false-value="play_mode") 編集

          //- template(v-for="(e, i) in question.moves_answers")
          //-   b-tag
          //-     | {{i + 1}}

          //- b-field(position="is-centered" grouped)
          //-   p.control
          //-     b-button(@click="edit_mode_handle" type="{'is-primary': sp_run_mode === 'edit_mode'") 配置
          //-   p.control
          //-     b-button(@click="play_mode_handle" type="{'is-primary': sp_run_mode === 'edit_mode'") 正解
          //-   p.control
          //-     b-button(@click="edit_mode_handle" type="{'is-primary': sp_run_mode === 'edit_mode'") 情報
          //-   b-button(@click="edit_mode_handle" type="{'is-primary': sp_run_mode === 'edit_mode'") 情報

          //- b-field(position="is-centered")
          //-   b-radio-button(v-model="sp_run_mode" native-value="edit_mode" @click.native="edit_mode_handle") 配置
          //-   b-radio-button(v-model="sp_run_mode" native-value="play_mode" @click.native="play_mode_handle") 正解

          b-tabs.main_tabs(v-model="edit_tab_index" expanded @change="tab_change_handle")
            b-tab-item(label="配置")
              shogi_player(
                :run_mode="'edit_mode'"
                :kifu_body="`position sfen ${question.init_sfen}`"
                :start_turn="-1"
                :key_event_capture="false"
                :slider_show="true"
                :controller_show="true"
                :theme="'simple'"
                :size="'default'"
                :sound_effect="false"
                :volume="0.5"
                @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen"
                )
            b-tab-item
              template(slot="header")
                span 正解
                b-tag(rounded) {{question.moves_answers.length}}
              shogi_player(
                :run_mode="'play_mode'"
                :kifu_body="`position sfen ${question.init_sfen}`"
                :start_turn="0"
                :key_event_capture="false"
                :slider_show="true"
                :controller_show="true"
                :setting_button_show="development_p"
                :theme="'simple'"
                :size="'default'"
                :sound_effect="edit_tab_info.key === 'play_mode'"
                :volume="0.5"
                @update:turn_offset="turn_offset_set"
                ref="play_sp"
                )

              .buttons.is-centered.konotejunsiikai
                b-button(@click="edit_stock_handle" :type="{'is-primary': answer_turn_offset >= 1}") この手順を正解とする

              b-tabs.answer_tabs(v-model="answer_tab_index" position="is-centered" expanded :animated="true" v-if="question.moves_answers.length >= 1")
                template(v-for="(e, i) in question.moves_answers")
                  b-tab-item(:label="`${i + 1}`" :key="`tab_${i}_${e.moves_str}`")
                    shogi_player(
                      :run_mode="'view_mode'"
                      :kifu_body="full_sfen_build(e)"
                      :start_turn="-1"
                      :debug_mode="false"
                      :key_event_capture="false"
                      :slider_show="true"
                      :controller_show="true"
                      :setting_button_show="development_p"
                      :theme="'simple'"
                      :size="'default'"
                      :sound_effect="true"
                      :volume="0.5"
                      )
                    b-button.delete_button(type="is-danger" icon-left="trash-can-outline" @click="kotae_delete_handle(i)" size="is-small")
            b-tab-item(label="情報")
              .input_forms
                b-field(label="タイトル" label-position="on-border")
                  b-input(v-model="question.title")

                b-field(label="説明" label-position="on-border")
                  b-input(v-model="question.description" size="is-small" type="textarea" rows="2")

                b-field(label="ヒント" label-position="on-border")
                  b-input(v-model="question.hint_description")

                b-field(label="出典" label-position="on-border")
                  b-input(v-model="question.source_desc")

                b-field(label="制限時間" label-position="on-border")
                  //- :default-seconds="0" :default-minutes="0"
                  b-timepicker(v-model="time_limit_clock" icon="clock" :enable-seconds="true")
                  //- b-numberinput(v-model="time_limit_clock" :min="0")
                  //- b-numberinput(v-model="time_limit_clock" :min="0")

                label.is-size-7.has-text-weight-bold 難易度
                b-rate(v-model="question.difficulty_level" spaced :max="start_level_max" :show-score="false")

            b-tab-item(label="試験")
              shogi_player(
                :run_mode="'play_mode'"
                :kifu_body="`position sfen ${question.init_sfen}`"
                :start_turn="0"
                :key_event_capture="false"
                :slider_show="true"
                :controller_show="true"
                :theme="'simple'"
                :size="'default'"
                :sound_effect="true"
                :volume="0.5"
                @update:play_mode_advanced_moves="play_mode_advanced_moves_set"
                )

          hr
          .save_container
            .buttons.is-centered
              b-button.has-text-weight-bold(@click="save_handle" :type="save_button_type") {{crete_or_upate_name}}
              //- b-button.has-text-weight-bold(@click="back_to_index_handle") 一覧に戻る

  debug_print

  dump(:data="info" label="info")
</template>

<script>
const WAIT_SECOND = 1.5

import consumer from "channels/consumer"
import MemoryRecord from 'js-memory-record'

import dayjs from "dayjs"

class EditTabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "edit_mode", name: "配置", },
      { key: "play_mode", name: "正解", },
      { key: "form_mode", name: "情報", },
      { key: "exam_mode", name: "試験", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

export default {
  name: "acns2_sample",
  props: {
    info: { required: true },
  },
  data() {
    return {
      mode: "lobby",
      room: this.info.room,

      matching_list: null,       // 対戦待ちの人のIDを列挙している
      online_user_ids: null,       // オンライン人数
      room_user_ids: null,       // オンライン人数
      quest_index: null,        // 正解中の問題インデックス
      freeze_mode: null,        // 正解直後に間を開けているとき true になっている
      progress_info: null,      // 各 membership_id はどこまで進んでいるかわかる {"1" => 2, "3" => 4}

      // チャット用
      messages: null,           // メッセージ(複数)
      message: null,            // 入力中のメッセージ

      // private
      $school: null,        // --> app/channels/acns2/school_channel.rb
      $lobby: null,         // --> app/channels/acns2/lobby_channel.rb
      $room: null,          // --> app/channels/acns2/room_channel.rb

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
      this.$school = consumer.subscriptions.create({channel: "Acns2::SchoolChannel"}, {
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
          this.$forceUpdate()
        },
      })
    },

    lobby_setup() {
      this.debug_alert("lobby_setup")
      this.__assert(this.$lobby == null)
      this.$lobby = consumer.subscriptions.create({channel: "Acns2::LobbyChannel"}, {
        connected: () => {
          this.debug_alert("lobby 接続")
        },
        disconnected: () => {
          this.debug_alert("lobby 切断")
        },
        received: (data) => {
          this.debug_alert("lobby 受信")

          if (data.matching_list) {
            this.matching_list = data.matching_list
          }

          if (data.room) {
            const membership = data.room.memberships.find(e => e.user.id === this.current_user.id)
            if (membership) {
              this.lobby_unsubscribe()

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
      this.$lobby.perform("matching_start")
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
      this.$room = consumer.subscriptions.create({ channel: "Acns2::RoomChannel", room_id: this.room.id }, {
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
        this.$room.perform("progress_info_share", {membership_id: this.current_membership.id, quest_index: this.quest_index + 1}) // --> app/channels/acns2/room_channel.rb

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
      if (this.progress_info) {
        return this.progress_info[membership.id] || 0
      }
    },

    login_required2() {
      if (!this.current_user) {
        this.self_window_open(this.login_path)
        return true
        // this.self_window_open("/xusers/sign_in")
      }
    },

    lobby_unsubscribe() {
      if (this.$lobby) {
        this.$lobby.unsubscribe()
        this.$lobby = null
        this.$forceUpdate()
      }
    },

    room_unsubscribe() {
      if (this.$room) {
        this.$room.unsubscribe()
        this.$room = null
        this.$forceUpdate()
      }
    },

    goto_edit_mode_handle() {
      this.sound_play("click")
      this.mode = "edit"
      this.edit_init_once()
      this.edit_setup()
    },

    edit_setup() {
      this.sp_run_mode = "edit_mode"
      this.edit_tab_index = EditTabInfo.fetch("edit_mode").code
    },

    edit_mode_snapshot_sfen(sfen) {
      if (this.sp_run_mode === "edit_mode") {
        sfen = sfen.replace(/position sfen /, "")

        // console.log(this.question.init_sfen)
        // console.log(sfen)

        if (this.question.init_sfen !== sfen) {
          this.debug_alert(`初期配置取得 ${sfen}`)
          this.$set(this.question, "init_sfen", sfen)

          // 合わせて正解も削除する
          if (this.question.moves_answers.length >= 1) {
            this.ok_notice("元の配置を変更したので正解を削除しました")
            this.moves_answers_clear()
          }
        }
      }
    },

    current_moves_str() {
      return this.$refs.play_sp.moves_take_turn_offset.join(" ")
    },

    edit_stock_handle() {
      const moves_str = this.current_moves_str()

      if (moves_str === "") {
        this.warning_notice("1手以上動かしてください")
        return
      }
      if (this.question.moves_answers.some(e => e.moves_str === moves_str)) {
        this.warning_notice("すでに同じ正解があります")
        return
      }

      this.question.moves_answers.push({moves_str: moves_str})
      this.$nextTick(() => this.answer_tab_index = this.question.moves_answers.length - 1)
      this.ok_notice(`${this.question.moves_answers.length}つ目の正解を追加しました`)
    },

    kotae_delete_handle(index) {
      const new_ary = this.question.moves_answers.filter((e, i) => i !== index)
      this.$set(this.question, "moves_answers", new_ary)
      this.$nextTick(() => this.answer_tab_index = _.clamp(this.answer_tab_index, 0, this.question.moves_answers.length - 1))
      this.ok_notice("削除しました")
    },

    full_sfen_build(moves_answer_attributes) {
      return ["position", "sfen", this.question.init_sfen, "moves", moves_answer_attributes.moves_str].join(" ")
    },

    ////////////////////////////////////////////////////////////////////////////////

    edit_mode_handle() {
      this.edit_setup()
    },

    play_mode_handle() {
      this.sp_run_mode = "play_mode"
      this.edit_tab_index = EditTabInfo.fetch("play_mode").code

      // この方法でも取得できる
      // if (this.$refs.play_sp) {
      //   this.$set(this.question, "init_sfen", this.$refs.play_sp.mediator.sfen_serializer.to_s)
      // }

      // this.$nextTick(() => {
      //   if (this.question.init_sfen == null) {
      //     const init_sfen = this.$refs.play_sp.init_sfen.replace(/position sfen /, "")
      //     this.debug_alert(`初期配置取得 ${init_sfen}`)
      //     this.$set(this.question, "init_sfen", init_sfen)
      //   }
      // })
    },

    form_mode_handle() {
      this.edit_tab_index = EditTabInfo.fetch("form_mode").code
    },

    exam_mode_handle() {
      this.$exam_run_count = 0
    },

    ////////////////////////////////////////////////////////////////////////////////

    edit_init_once() {
      this.jump_to_index_handle()
    },

    // clock = advance(seconds: sec)
    time_limit_clock_set() {
      this.time_limit_clock = this.base_clock.add(this.question.time_limit_sec, "second").toDate()
    },

    // 正解だけを削除
    moves_answers_clear() {
      this.$set(this.question, "moves_answers", [])
      this.answer_tab_index = 0
    },

    tab_change_handle() {
      this[this.edit_tab_info.handle_method_name]()
    },

    save_handle() {
      if (this.question.moves_answers.length === 0) {
        this.warning_notice("正解を作ってください")
        return
      }

      // const moves_answers = this.answers.map(e => {
      //   return { moves_str: e.moves_str }
      // })

      // https://day.js.org/docs/en/durations/diffing
      const time_limit_sec = dayjs(this.time_limit_clock).diff(this.base_clock) / 1000

      const params = {question: { ...this.question, time_limit_sec: time_limit_sec }}

      // .add(this.question.time_limit_sec, "second").toDate()

      // params.set("question.description", this.question.description)
      // params.set("init_sfen", this.init_sfen)
      // params.set("answers", this.answers)

      const before_crete_or_upate_name = this.crete_or_upate_name
      this.http_command("PUT", this.info.put_path, params, e => {
        if (e.error_message) {
          this.warning_notice(e.error_message)
        }
        if (e.question) {
          // 別に更新する必要はないけどサーバー側から他の情報が追加されているかもしれない
          this.question = e.question

          // alert(this.time_limit_clock)
          // dayjs("2000-01-01T00:03:00+09:00").toDate()
          // this.time_limit_clock = dayjs(this.time_limit_clock).toDate()
          // console.log(this.time_limit_clock)
          this.time_limit_clock_set()
          this.ok_notice(`${before_crete_or_upate_name}しました`)
        }
      })
    },

    warning_dialog(message) {
      this.$buefy.dialog.alert({
        title: "ERROR",
        message: message,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        hasIcon: true,
        icon: "times-circle",
        iconPack: "fa",
        trapFocus: true,
      })
    },

    ok_notice(message) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-success", queue: false})
      this.talk(message, {rate: 1.5})
    },

    warning_notice(message) {
      this.sound_play("x")
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-warning", queue: false})
      this.talk(message, {rate: 1.5})
    },

    jump_to_index_handle(event) {
      if (event) {
        this.sound_play("click")
      }
      this.question = null
      this.async_records_load()
    },

    jump_to_new_handle() {

      // this.provisional_sfen = "4k4/9/9/9/9/9/9/9/9 b k2r2b4g4s4n4l18p 1"
      // if (this.development_p) {
      //   this.provisional_sfen = "4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1"
      //   this.provisional_sfen = "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1"
      // }

      const question = {
        init_sfen: "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
        moves_answers: [],
        time_limit_sec: 3 * 60,
        difficulty_level: 1,
      }

      this.question_edit_of(question)
    },

    question_edit_of(row) {
      this.sound_play("click")

      this.question = row
      this.time_limit_clock_set()

      this.edit_tab_index = 0   // 配置モード
      this.answer_tab_index = 0 // 解答リストの一番左指す
      this.answer_turn_offset = 0
    },

    back_to_index_handle() {
      this.jump_to_index_handle()
    },

    page_change_handle(page) {
      this.page = page
      this.async_records_load()
    },

    sort_handle(column, order) {
      this.sort_column = column
      this.sort_order = order
      this.async_records_load()
    },

    async_records_load() {
      this.http_get_command(this.info.put_path, {
        index_fetch: true,
        page:               this.page,
        per:                this.per,
        sort_column:        this.sort_column,
        sort_order:         this.sort_order,
        sort_order_default: this.sort_order_default,
      }, e => {
        if (e.error_message) {
          this.warning_notice(e.error_message)
        }
        if (e.questions) {
          this.questions   = e.questions

          this.total              = e.total
          this.page               = e.page
          this.per                = e.per
          this.sort_column        = e.sort_column
          this.sort_order         = e.sort_order
          this.sort_order_default = e.sort_order_default
        }
      })
    },

    play_mode_advanced_moves_set(moves) {
      if (this.question.moves_answers.length === 0) {
        if (this.$exam_run_count === 0) {
          this.warning_notice("正解を作ってからやってください")
        }
      }
      if (this.question.moves_answers.some(e => e.moves_str === moves.join(" "))) {
        this.sound_play("o")
        this.ok_notice("正解")
      }
      this.$exam_run_count += 1
    },

    turn_offset_set(v) {
      this.answer_turn_offset = v
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

    edit_tab_info() {
      return EditTabInfo.fetch(this.edit_tab_index)
    },

    crete_or_upate_name() {
      if (this.question.id) {
        return "更新"
      } else {
        return "作成"
      }
    },

    start_level_max() {
      return 5
    },

    base_clock() {
      return dayjs("2000-01-01T00:00:00+09:00")
    },

    save_button_type() {
      if (this.question.moves_answers.length >= 1) {
        return "is-primary"
      }
    },

    // candidate_columns() {
    //   return [
    //     { field: "順位",       label: "順位",       sortable: true, numeric: true, },
    //     { field: "候補手",     label: "候補手",                                    },
    //     { field: "読み筋",     label: "読み筋",                                    },
    //     { field: "▲形勢",     label: "▲形勢",     sortable: true, numeric: true, },
    //     { field: "評価局面数", label: "評価局面数", sortable: true, numeric: true, },
    //     { field: "処理時間",   label: "処理時間",   sortable: true, numeric: true, },
    //   ]
    // },

  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.acns2_sample
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

  //////////////////////////////////////////////////////////////////////////////// 編集

  // .switch_grouped_container
  //   margin-top: 0.5rem
  .main_tabs
    .tab-content
      padding: 0
      padding-top: 0.75rem
    .tag
      margin-left: 0.5rem

  // この手順を正解にする
  .konotejunsiikai
    margin-top: 0.3rem

  // 正解のタブ
  .answer_tabs
    margin-top: 0.8rem
    .tab-content
      padding: 0.8rem 0
      position: relative
      .delete_button
        position: absolute
        top: 0.5rem
        right: 0.5rem

  // タイトルと説明
  .input_forms
    margin-top: 0.8rem

  ////////////////////////////////////////////////////////////////////////////////
  .save_container

  //////////////////////////////////////////////////////////////////////////////// 共通
</style>
