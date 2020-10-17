<template lang="pug">
.CpuBattleApp.has-background-white-ter
  MainNavbar
    template(slot="brand")
      HomeNavbarItem
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'cpu-battle'}") CPU対戦
  .section
    .container
      .columns
        .column.is_shogi_player
          template(v-if="mode === 'playing' || mode === 'standby'")
            nav.level.is-mobile
              .level-item
                .buttons
                  template(v-if="mode === 'standby'")
                    b-button(type="is-primary" @click="start_handle" :rounded="true")
                      | 対局開始
                  template(v-if="mode === 'playing'")
                    b-button(@click="give_up_handle" :rounded="true" :loading="give_up_processing")
                      | 投了
                    template(v-if="development_p")
                      b-button(@click="candidate_handle" :loading="candidate_processing")
                        | 形勢判断
                      b-button(@click="break_handle")
                        | 終了
                      b-button(@click="restart_handle")
                        | 再挑戦
                      b-button(@click="one_hand_exec")
                        | 1手指す
                      b-button(@click="retract_a_move")
                        | 待った
                      b-button(@click="judge_dialog_display({judge_key: 'win', message: 'かち'})")
                        | win
                      b-button(@click="judge_dialog_display({judge_key: 'lose', message: 'まけ'})")
                        | lose

          .has-text-centered
            MyShogiPlayer(
              :kifu_body="current_sfen"
              :human_side_key="human_side_key"
              :theme="sp_params.theme"
              :bg_variant.sync="bg_variant"
              :piece_variant="sp_params.piece_variant"
              :key_event_capture="false"
              :sfen_show="false"
              :slider_show="development_p || mode === 'standby'"
              :controller_show="development_p || mode === 'standby'"
              :size="'large'"
              :run_mode="mode === 'standby' ? 'view_mode' : 'play_mode'"
              :flip.sync="flip"
              :setting_button_show="development_p"
              :summary_show="development_p"
              @update:play_mode_advanced_full_moves_sfen="play_mode_advanced_full_moves_sfen_set"
              ref="main_sp"
            )

            .mt-3(v-if="mode === 'standby'")
              .mx-1.is-size-7.has-text-grey CPUの成績
              .mx-1.is-size-6.has-text-weight-bold {{judge_group.lose || 0}}勝{{judge_group.win || 0}}敗

        .column.is-two-fifths
          template(v-if="mode === 'standby'")
            .box
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
              hr
              b-field(label="スタイル" custom-class="is-small")
                .block
                  template(v-for="e in BoardStyleInfo.values")
                    b-radio(v-model="sp_params.board_style_key" :native-value="e.key"  size="is-small")
                      | {{e.name}}
              b-button(@click="bg_variant_reset_handle" size="is-small")
                | ランダム盤

              template(v-if="development_p")
                | &nbsp;
                | &nbsp;
                b-tooltip(label="指し手の読み上げ")
                  template(v-if="yomiage_mode")
                    b-button(@click="yomiage_mode_set(false)" size="is-small" icon-left="volume-high")
                  template(v-if="!yomiage_mode")
                    b-button(@click="yomiage_mode_set(true)" size="is-small" icon-left="volume-off")

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
            canvas#chart_canvas(ref="main_canvas")
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
// import shogi_player from "shogi-player/src/components/ShogiPlayer.vue"

// static
import { CpuBrainInfo    } from "./models/CpuBrainInfo.js"
import { CpuStrategyInfo } from "./models/CpuStrategyInfo.js"
import { CpuPresetInfo   } from "./models/CpuPresetInfo.js"
import { BoardStyleInfo  } from "./models/BoardStyleInfo.js"

import PresetInfo      from "shogi-player/src/preset_info.js"
import Location        from "shogi-player/src/location.js"

import { cpu_battle_force_chart } from "./cpu_battle_force_chart.js"

const BG_VARIANT_AVAILABLE_LIST = ["a", "g", "l", "n", "p", "q"] // 有効な背景の種類

export default {
  name: "CpuBattleApp",
  mixins: [
    cpu_battle_force_chart,
  ],
  props: {
    config: { type: Object, required: true },
  },
  components: {
    // shogi_player,
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
      yomiage_mode: true,

      // 候補手
      candidate_report: null, // テキスト
      candidate_rows: null,   // 配列

      // デバッグ用
      pressure_rate_hash: null, // 終盤度
      think_text:         null, // 思考内容テキスト

      // shogi-player 用パラメータ
      current_sfen: null,               // 譜面
      flip: null,                       // 駒落ちなら反転させる
      sp_params: this.config.sp_params, // スタイル(createdで反映させるとwatchが反応してしまう)
      bg_variant: null,                 // 背景の種類
      human_side_key: null,             // 人間が操作する側を絞る
    }
  },

  created() {
    CpuBrainInfo.memory_record_reset(this.config.cpu_brain_infos)
    CpuStrategyInfo.memory_record_reset(this.config.cpu_strategy_infos)
    CpuPresetInfo.memory_record_reset(this.config.cpu_preset_infos)

    this.board_style_info_reflection()

    this.mode = "standby"

    this.current_sfen_set()

    this.bg_variant = "a"

    this.give_up_processing = false
    this.candidate_processing = false
  },

  mounted() {
    if (this.$route.query.auto_play) {
      this.start_handle()
    }
  },

  computed: {
    CpuBrainInfo()    { return CpuBrainInfo    },
    CpuStrategyInfo() { return CpuStrategyInfo },
    CpuPresetInfo()   { return CpuPresetInfo   },
    BoardStyleInfo()  { return BoardStyleInfo  },
    Location()        { return Location        },

    board_style_info()  { return BoardStyleInfo.fetch(this.sp_params.board_style_key) },
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
        yomiage_mode:               this.yomiage_mode,
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
      this.current_sfen_set()
      this.talk(`${this.cpu_preset_info.name}に変更しました`)
    },

    // 盤面
    "sp_params.board_style_key": function() {
      this.board_style_info_reflection()
      this.talk(`${this.board_style_info.name}に変更しました`)
    },
  },

  methods: {
    cpu_strategy_random_number_reset() {
      this.cpu_strategy_random_number = Math.floor(Math.random() * 256) // オールラウンドの戦法が決まる乱数
    },

    current_sfen_set() {
      this.current_sfen = this.preset_info.sfen                     // 手合割に対応する盤面設定
      this.flip = (this.preset_info.first_location_key === "white") // 駒落ちなら反転して上手を持つ
      this.human_side_key = this.preset_info.first_location_key     // 人間側だけの操作にする
      // this.$nextTick(() => this.$refs.main_sp.$refs.pure_sp.current_turn_set(0))  // 0手目の局面に戻す
      // this.$nextTick(() => this.$refs.main_sp.$refs.pure_sp.api_board_turn_set(0))  // 0手目の局面に戻す
    },

    // 再挑戦
    restart_handle() {
      this.start_handle()
    },

    // 開始
    start_handle() {
      this.sound_play("click")

      this.current_sfen_set()

      // オールラウンドの戦型選択
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
          this.human_side_key = _.sample(Location.keys) // 振り駒をして
          if (this.human_side_key === "white") {        // 後手番なら
            this.flip = true                            // 盤面反転して
            this.$nextTick(() => this.one_hand_exec())  // 相手に初手を指させる
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
      this.play_mode_advanced_full_moves_sfen_set(this.$refs.main_sp.$refs.pure_sp.play_mode_full_moves_sfen)
    },

    // 待った
    retract_a_move() {
      this.$refs.main_sp.$refs.pure_sp.api_retract_a_move()
    },

    // 背景ランダム設定
    bg_variant_reset_handle() {
      while (true) {
        let v = _.sample(BG_VARIANT_AVAILABLE_LIST)
        if (this.bg_variant !== v) {
          this.sound_play("click")
          this.bg_variant = v
          break
        }
      }
    },

    yomiage_mode_set(mode) {
      this.yomiage_mode = mode
    },

    board_style_info_reflection() {
      this.board_style_info.func(this.sp_params)
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

      // standby にすると shogi-player を view_mode に切り替える
      // そのとき局面が0手目になってしまうので、最後の局面にする
      this.$nextTick(() => this.$refs.main_sp.$refs.pure_sp.api_board_turn_set(10000))
      // this.$nextTick(() => this.$refs.main_sp.$refs.pure_sp.current_turn_set(10000))
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
      this.post_apply({candidate_sfen: this.current_sfen})
    },

    play_mode_advanced_full_moves_sfen_set(long_sfen) {
      if (this.mode === "standby") {
        return
      }
      this.post_apply({kifu_body: long_sfen})
    },

    post_apply(params) {
      this.$axios.$post("/api/cpu_battle", {...this.post_shared_params, ...params}).then(data => this.response_process(data))
    },

    response_process(e) {
      if (this.mode === "playing") {
        // CPUの指し手を読み上げる
        if (e["yomiage"]) {
          if (this.yomiage_mode) {
            this.talk(e["yomiage"])
          }
        }

        // 指した後の局面を反映
        if (e["current_sfen"]) {
          this.current_sfen = e["current_sfen"]
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
        this.sound_play("win")
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
        this.sound_play("lose")
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
  min-height: 100vh

  +mobile
    .section
      padding: 2.8rem 0.5rem 0
    .column
      padding: 0
      margin: 1.25rem
      &.is_shogi_player
        padding: 0
        margin: 0

  .table_format_area
    line-height: 100%

  .label_with_progress
    display: flex
    align-items: center
    progress
      margin-left: 0.25rem
      width: 100%
</style>
