<template lang="pug">
.CpuBattleApp
  b-navbar(type="is-dark" fixed-bottom v-if="development_p && (mode === 'playing' || mode === 'standby')")
    template(slot="start")
      b-navbar-item(@click="candidate_handle" :loading="candidate_processing") 形勢判断
      b-navbar-item(@click="break_handle") 終了
      b-navbar-item(@click="restart_handle") 再挑戦
      b-navbar-item(@click="one_hand_exec") 1手指す
      b-navbar-item(@click="retract_a_move") 待った
      b-navbar-item(@click="judge_dialog_display({judge_key: 'win', message: 'かち'})") win
      b-navbar-item(@click="judge_dialog_display({judge_key: 'lose', message: 'まけ'})") lose

  MainNavbar
    template(slot="brand")
      template(v-if="mode === 'standby'")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'cpu-battle'}") CPU対戦
      template(v-if="development_p")
        b-navbar-item \#{{turn_offset}}

    template(slot="end")
      b-navbar-item.has-text-weight-bold.start_handle(tag="div" @click="start_handle" v-if="mode === 'standby'")
        .button.is-primary.is-light 対局開始

      b-navbar-item.has-text-weight-bold(tag="div" @click="give_up_handle" :loading="give_up_processing" v-if="mode === 'playing'")
        .button.is-primary.is-light 投了

  MainSection.is_mobile_padding_zero
    .container
      .columns
        .column
          .CustomShogiPlayerWrap
            CustomShogiPlayer(
              :sp_body="sp_body"
              :sp_human_side="sp_human_side"
              :sp_slider="mode === 'standby'"
              :sp_controller="mode === 'standby'"
              :sp_mode="mode === 'standby' ? 'view' : 'play'"
              :sp_viewpoint.sync="viewpoint"
              @ev_play_mode_move="ev_play_mode_move"
              v-bind="free_move_attrs"
              ref="main_sp"
            )
          .has-text-centered.mt-3(v-if="mode === 'standby'")
            .mx-1.is-size-7.has-text-grey CPUの成績
            .mx-1.is-size-5.has-text-weight-bold {{judge_group.lose || 0}}勝 {{judge_group.win || 0}}敗

        .column.is-one-third
          .box(v-if="mode === 'standby'")
            .content
              h4 設定
            b-field(label="強さ" custom-class="is-small")
              .block
                template(v-for="e in CpuBrainInfo.values")
                  b-radio(v-model="cpu_brain_key" :native-value="e.key" size="is-small")
                    | {{e.name}}

            b-field(label="戦法" custom-class="is-small")
              .block
                template(v-for="e in CpuStrategyInfo.values")
                  b-radio(v-model="cpu_strategy_key" :native-value="e.key" size="is-small")
                    | {{e.name}}

            b-field(label="手合" custom-class="is-small")
              .block
                template(v-for="e in CpuPresetInfo.values")
                  b-radio(v-model="cpu_preset_key" :native-value="e.key" size="is-small")
                    | {{e.name}}

          template(v-if="mode === 'playing'")
            template(v-if="candidate_rows")
              .buttons
                b-button(@click="candidate_handle" :loading="candidate_processing")
                  | 自分の形勢判断
              template(v-if="!candidate_processing")
                .box
                  b-table(:data="candidate_rows" :mobile-cards="false" :hoverable="true" :columns="candidate_columns" narrowed)

          template(v-if="pressure_rate_hash")
            .box
              small
                b 終盤度
              template(v-for="e in Location.values")
                .label_with_progress
                  | {{e.name}}
                  progress.progress.is-danger.is-small(:value="pressure_rate_hash[e.key] * 100" :max="100")
              template(v-if="development_p")
                | {{pressure_rate_hash}}

          .box
            canvas(ref="main_canvas")
            template(v-if="development_p && false")
              | {{chart_config.data.datasets[0].data}}

      template(v-if="development_p && mode === 'playing'")
        .columns
          .column
            template(v-if="think_text")
              pre.box.is-size-7.table_format_area
                | {{think_text}}
          .column
            template(v-if="candidate_report")
              pre.box.is-size-7.table_format_area
                | {{candidate_report}}
        .columns(v-if="development_p && mode === 'playing'")
          .column.is-half
            template(v-if="candidate_rows")
              .box
                b-table(:data="candidate_rows" :mobile-cards="false" :hoverable="true" :columns="candidate_columns" narrowed)
</template>

<script>
import _ from "lodash"

// static
import { CpuBrainInfo    } from "./models/CpuBrainInfo.js"
import { CpuStrategyInfo } from "./models/CpuStrategyInfo.js"
import { CpuPresetInfo   } from "./models/CpuPresetInfo.js"

import { PresetInfo } from "shogi-player/components/models/preset_info.js"
import { Location } from "shogi-player/components/models/location.js"

import { cpu_battle_force_chart } from "./cpu_battle_force_chart.js"

export default {
  name: "CpuBattleApp",
  mixins: [
    cpu_battle_force_chart,
  ],
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      // -------------------------------------------------------------------------------- dynamic
      mode: null,                                   // 現在の状態
      give_up_processing: null,                     // 投了処理中(連打防止用)
      judge_group: this.config.judge_group,         // 勝敗
      candidate_processing: null,                   // 形勢判断中

      // 設定用
      cpu_brain_key:    this.config.cpu_brain_key,    // 強さ
      cpu_strategy_key: this.config.cpu_strategy_key, // 戦法
      cpu_preset_key:   this.config.cpu_preset_key,   // 手合
      cpu_strategy_random_number: null,               // オールラウンド時の戦法選択用乱数

      // 候補手
      candidate_report: null, // テキスト
      candidate_rows:   null, // 配列

      // デバッグ用
      pressure_rate_hash: null, // 終盤度
      think_text:         null, // 思考内容テキスト
      turn_offset:        null, // 手数

      // shogi-player 用パラメータ
      sp_body:       null, // 譜面
      viewpoint:  null, // 駒落ちなら反転させる
      sp_human_side: null, // 人間が操作する側を絞る
    }
  },

  created() {
    CpuBrainInfo.memory_record_reset(this.config.cpu_brain_infos)
    CpuStrategyInfo.memory_record_reset(this.config.cpu_strategy_infos)
    CpuPresetInfo.memory_record_reset(this.config.cpu_preset_infos)

    this.mode = "standby"

    this.sp_body_set()

    this.give_up_processing = false
    this.candidate_processing = false
  },

  mounted() {
    this.app_log("CPU対戦")
    if (this.$route.query.auto_play) {
      this.start_handle()
    }
  },

  computed: {
    CpuBrainInfo()    { return CpuBrainInfo    },
    CpuStrategyInfo() { return CpuStrategyInfo },
    CpuPresetInfo()   { return CpuPresetInfo   },
    Location()        { return Location        },

    cpu_brain_info()    { return CpuBrainInfo.fetch(this.cpu_brain_key)               },
    cpu_strategy_info() { return CpuStrategyInfo.fetch(this.cpu_strategy_key)         },
    cpu_preset_info()   { return CpuPresetInfo.fetch(this.cpu_preset_key)             },
    preset_info()       { return PresetInfo.fetch(this.cpu_preset_info.key)           },

    candidate_columns() {
      const columns = []
      if (this.development_p) {
        columns.push({ field: "順位",       label: "順位",       sortable: true, numeric: true, })
      }

      columns.push({ field: "候補手",     label: "候補手",                                    })
      columns.push({ field: "▲形勢",     label: "評価値",     sortable: true, numeric: true, })

      if (this.development_p) {
        columns.push({ field: "読み筋",     label: "読み筋",                                    }),
        columns.push({ field: "評価局面数", label: "評価局面数", sortable: true, numeric: true, }),
        columns.push({ field: "処理時間",   label: "処理時間",   sortable: true, numeric: true, })
      }

      return columns
    },

    post_shared_params() {
      return {
        cpu_brain_key:              this.cpu_brain_key,
        cpu_strategy_key:           this.cpu_strategy_key,
        cpu_strategy_random_number: this.cpu_strategy_random_number,
        cpu_preset_key:             this.cpu_preset_key,
      }
    },

    free_move_attrs() {
      return {
        sp_legal_move_only:        false, // play で合法手のみに絞る
        sp_illegal_validate:       false, // play 反則判定をするか？
        sp_piece_auto_promote:     false, // play で死に駒になるときは自動的に成る
        sp_my_piece_only_move:     false, // play では自分手番とき自分の駒しか動かせないようにする
        sp_my_piece_kill_disabled: false, // play では自分の駒で同じ仲間の駒を取れないようにする
      }
    },
  },

  watch: {
    cpu_brain_key() {
      this.talk(`${this.cpu_brain_info.name}に変更しました`)
    },

    cpu_strategy_key() {
      this.talk(`${this.cpu_strategy_info.name}に変更しました`)
    },

    cpu_preset_key() {
      this.sp_body_set()
      this.talk(`${this.cpu_preset_info.name}に変更しました`)
    },
  },

  methods: {
    cpu_strategy_random_number_reset() {
      this.cpu_strategy_random_number = Math.floor(Math.random() * 256) // オールラウンドの戦法が決まる乱数
    },

    sp_body_set() {
      this.sp_body   = this.preset_info.sfen                   // 手合割に対応する盤面設定
      this.viewpoint      = this.preset_info.first_location_key     // 駒落ちなら反転して上手を持つ
      this.sp_human_side = this.preset_info.first_location_key     // 人間側だけの操作にする

      // this.$nextTick(() => this.$refs.main_sp.sp_object().current_turn_set(0))  // 0手目の局面に戻す
      // this.$nextTick(() => this.$refs.main_sp.sp_object().api_board_turn_set(0))  // 0手目の局面に戻す
    },

    // 再挑戦
    restart_handle() {
      this.start_handle()
    },

    // 開始
    start_handle() {
      this.app_log("CPU対戦●")

      this.sfx_click()

      this.sp_body_set()

      // オールラウンドの戦法選択
      this.cpu_strategy_random_number_reset()

      // 候補手クリア
      this.candidate_report = null
      this.candidate_rows = null
      this.think_text = null
      this.pressure_rate_hash = null

      // 評価グラフ
      this.chart_reset()

      // 投了を押せる状態にする
      this.give_up_processing = false

      // 形勢判断してない状態にする
      this.candidate_processing = false

      // 開始
      this.mode = "playing"
      this.talk("よろしくお願いします")
      this.post_apply({start_trigger: true})

      // 平手であれば振り駒(ただしテストのときは先手からとする)
      if (!this.development_p) {
        if (this.preset_info.first_location_key === "black") {
          this.sp_human_side = _.sample(Location.keys) // 振り駒をして
          this.viewpoint = this.sp_human_side          // 視点を合わせて
          if (this.sp_human_side === "white") {        // 後手番なら
            this.$nextTick(() => this.one_hand_exec())  // 先手に初手を指させる
          }
        }
      }

      // 挨拶
      // setTimeout(() => this.talk(this.first_talk_body), 1000 * 0)
    },

    // 終了
    break_handle() {
      this.view_mode_set()
      this.$buefy.toast.open("終了")
    },

    // 1手実行
    one_hand_exec() {
      const sfen = this.$refs.main_sp.sp_object().play_mode_full_moves_sfen
      this.ev_play_mode_move({sfen})
    },

    // 待った
    retract_a_move() {
      this.$refs.main_sp.sp_object().api_retract_a_move()
    },

    easy_dialog(params) {
      params = {
        ...params,
        // 連打でスキップしてしまうことがあるため指定しない
        // canCancel: ["outside", "escape"],
        animation: "",
        trapFocus: true,
      }
      this.$buefy.dialog.alert(params)
    },

    view_mode_set() {
      this.mode = "standby"

      // standby にすると shogi-player を view に切り替える
      // そのとき局面が0手目になってしまうので、最後の局面にする
      this.$nextTick(() => this.$refs.main_sp.sp_object().api_board_turn_set(10000))
      // this.$nextTick(() => this.$refs.main_sp.sp_object().current_turn_set(10000))
    },

    give_up_handle() {
      if (this.give_up_processing) {
        return
      }
      this.give_up_processing = true
      this.post_apply({i_give_up: true})
    },

    candidate_handle() {
      if (this.candidate_processing) {
        return
      }
      this.candidate_processing = true
      this.post_apply({candidate_sfen: this.sp_body})
    },

    ev_play_mode_move(e) {
      if (this.mode === "standby") {
        return
      }
      this.post_apply({kifu_body: e.sfen})
    },

    post_apply(params) {
      this.$axios.$post("/api/cpu_battle", {...this.post_shared_params, ...params}).then(data => this.response_process(data))
    },

    response_process(e) {
      if (this.mode === "playing") {
        // CPUの指し手を読み上げる
        if (e["yomiage"]) {
          this.talk(e["yomiage"])
        }

        // 指した後の局面を反映
        if (e["current_sfen"]) {
          this.sp_body = e["current_sfen"]
        }

        // 何かとのときに使う用
        if (e["turn_offset"]) {
          this.turn_offset = e["turn_offset"]
        }

        // if (e["hand"]) {
        //
        //   this.chart_config.data.labels.push(e["turn_max"])
        //   this.chart_config.data.datasets[0].data.push({x: e["turn_max"], y: e["score"]})
        //   this.chart_instance.update()
        //
        //   console.log(e["hand"])
        // }

        this.score_list_reflection(e)

        this.candidate_processing = false
        this.candidate_rows = e["candidate_rows"]

        this.candidate_report = e["candidate_report"]
        this.think_text = e["think_text"]

        if (e["pressure_rate_hash"]) {
          this.pressure_rate_hash = e["pressure_rate_hash"]
        }

        if (e["judge_key"]) {
          this.view_mode_set()
          this.give_up_processing = false
          this.judge_group = e["judge_group"]
          this.judge_dialog_display(e)
        }
      }
    },

    judge_dialog_display(data) {
      if (data["judge_key"] === "win") {
        this.sfx_play("win")
        this.talk(data["message"])
        this.easy_dialog({
          title: "勝利",
          message: data["message"],
          type: "is-primary",
          hasIcon: true,
          icon: "trophy",
          iconPack: "mdi",
        })
      }
      if (data["judge_key"] === "lose") {
        this.sfx_play("lose")
        if (data["irregular"]) {
          this.talk("反則負けです")
          this.easy_dialog({
            title: "反則負け",
            message: data["message"],
            type: "is-danger",
            hasIcon: true,
          })
        } else {
          this.talk(data["message"])
          this.easy_dialog({
            title: "敗北",
            message: data["message"],
            type: "is-primary",
            hasIcon: true,
            icon: "emoticon-sad-outline",
            iconPack: "mdi",
          })
        }
      }
    },
  },
}
</script>

<style lang="sass">
.CpuBattleApp
  .CustomShogiPlayerWrap
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column

  .CustomShogiPlayer
    +tablet
      max-width: 640px - 32px * 3

  .table_format_area
    line-height: 100%

  .label_with_progress
    display: flex
    align-items: center
    progress
      margin-left: 0.25rem
      width: 100%

.STAGE-development
  .CpuBattleApp
    .container, .column, .CustomShogiPlayer
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
