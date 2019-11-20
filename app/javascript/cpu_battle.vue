<template lang="pug">
.cpu_battle
  .columns
    .column
      template(v-if="mode === 'playing' || mode === 'standby'")
        nav.level.is-mobile
          .level-item
            .buttons
              template(v-if="mode === 'standby'")
                b-button(type="is-primary" @click="start_handle" :rounded="true")
                  | 対局開始
              template(v-if="mode === 'playing'")
                b-button(type="is-danger" outlined @click="give_up_handle" :rounded="true" :loading="give_up_processing")
                  | 投了
                template(v-if="development_p")
                  b-button(@click="break_handle")
                    | 終了
                  b-button(@click="restart_handle")
                    | 再挑戦
                  b-button(@click="one_hand_exec")
                    | 1手指す

      .has-text-centered
        shogi_player(
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
          :sound_effect="true"
          :volume="$root.$options.volume"
          :run_mode="mode === 'standby' ? 'view_mode' : 'play_mode'"
          :flip.sync="flip"
          :setting_button_show="development_p"
          :summary_show="development_p"
          @update:play_mode_long_sfen="play_mode_long_sfen_set"
          ref="sp_vm"
        )

    .column.is-two-fifths
      template(v-if="mode === 'standby'")
        .content
          h3 設定
        template(v-if="false")
          .box
            nav.level.is-mobile
              .level-item.has-text-centered
                div
                  p.heading CPUの勝ち
                  p.title 1
              .level-item.has-text-centered
                div
                  p.heading 人間の勝ち
                  p.title 1
        .box
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

          b-field(label="手合割" custom-class="is-small")
            .block
              template(v-for="e in CpuPresetInfo.values")
                b-radio(v-model="cpu_preset_key" :native-value="e.key" size="is-small")
                  | {{e.name}}
        .box
          b-field(label="スタイル" custom-class="is-small")
            .block
              template(v-for="e in BoardStyleInfo.values")
                b-radio(v-model="sp_params.board_style_key" :native-value="e.key"  size="is-small")
                  | {{e.name}}
          b-button(@click="bg_variant_reset_handle" size="is-small")
            | ランダム盤

          | &nbsp;
          | &nbsp;
          b-tooltip(label="指し手の読み上げ")
            template(v-if="yomiage_mode")
              b-button(@click="yomiage_mode_set(false)" size="is-small" icon-left="volume-high")
            template(v-if="!yomiage_mode")
              b-button(@click="yomiage_mode_set(true)" size="is-small" icon-left="volume-off")

        b-message(size="is-small")
          | CPU: {{judge_group.lose}}勝 &nbsp;&nbsp; 人間: {{judge_group.win}}勝

      .box
        canvas#chart_canvas(ref="chart_canvas")
        template(v-if="development_p")
          | {{chart_config.data.datasets[0].data}}

  .columns(v-if="development_p && mode === 'playing'")
    .column
      template(v-if="candidate_rows")
        .box
          b-table(:data="candidate_rows" :mobile-cards="false" :hoverable="true" :columns="candidate_columns" narrowed)

      template(v-if="candidate_report")
        pre.box.is-size-7.candidate_report
          | {{candidate_report}}

</template>

<script>
import _ from "lodash"
import CpuBrainInfo from "cpu_brain_info"
import CpuStrategyInfo from "cpu_strategy_info"
import CpuPresetInfo from "cpu_preset_info"
import BoardStyleInfo from "board_style_info"
import PresetInfo from "shogi-player/src/preset_info.js"
import Location from "shogi-player/src/location"
import cpu_battle_force_chart from "./cpu_battle_force_chart.js"

const BG_VARIANT_AVAILABLE_LIST = ["a", "g", "l", "n", "p", "q"] // 有効な背景の種類

export default {
  name: "cpu_battle",
  mixins: [
    cpu_battle_force_chart,
  ],

  data() {
    return {
      // -------------------------------------------------------------------------------- static
      current_user: js_global.current_user, // 名前を読み上げるため

      // -------------------------------------------------------------------------------- dynamic
      mode: null,                                   // 現在の状態
      give_up_processing: null,                     // 投了処理中(連打防止用)
      judge_group: this.$root.$options.judge_group, // 勝敗

      // 設定用
      cpu_strategy_random_number: null,                       // オールラウンド時の戦法選択用乱数
      cpu_brain_key: this.$root.$options.cpu_brain_key,       // 強さ
      cpu_strategy_key: this.$root.$options.cpu_strategy_key, // 戦法
      cpu_preset_key: this.$root.$options.cpu_preset_key,     // 手合
      yomiage_mode: true,

      // 候補手
      candidate_report: null, // テキスト
      candidate_rows: null,   // 配列

      // shogi-player 用パラメータ
      current_sfen: null,                       // 譜面
      flip: null,                               // 駒落ちなら反転させる
      sp_params: this.$root.$options.sp_params, // スタイル(createdで反映させるとwatchが反応してしまう)
      bg_variant: null,                         // 背景の種類
      human_side_key: null,                     // 人間が操作する側を絞る
    }
  },

  created() {
    CpuBrainInfo.memory_record_reset(this.$root.$options.cpu_brain_infos)
    CpuStrategyInfo.memory_record_reset(this.$root.$options.cpu_strategy_infos)
    CpuPresetInfo.memory_record_reset(this.$root.$options.cpu_preset_infos)

    this.board_style_info_reflection()

    this.mode = "standby"

    this.current_sfen_set()

    this.bg_variant = "a"

    this.give_up_processing = false

    console.log("this.$route.query:", this.$route.query)
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

    board_style_info()  { return BoardStyleInfo.fetch(this.sp_params.board_style_key) },
    cpu_brain_info()    { return CpuBrainInfo.fetch(this.cpu_brain_key)               },
    cpu_strategy_info() { return CpuStrategyInfo.fetch(this.cpu_strategy_key)         },
    cpu_preset_info()   { return CpuPresetInfo.fetch(this.cpu_preset_key)             },
    preset_info()       { return PresetInfo.fetch(this.cpu_preset_info.key)           },

    candidate_columns() {
      return [
        { field: "順位",       label: "順位",       sortable: true, numeric: true, },
        { field: "候補手",     label: "候補手",                                    },
        { field: "読み筋",     label: "読み筋",                                    },
        { field: "▲形勢",     label: "▲形勢",     sortable: true, numeric: true, },
        { field: "評価局面数", label: "評価局面数", sortable: true, numeric: true, },
        { field: "処理時間",   label: "処理時間",   sortable: true, numeric: true, },
      ]
    },

    // // 対戦者の名前
    // current_call_name() {
    //   let str = null
    //   if (!str) {
    //     if (this.current_user) {
    //       str = `${this.current_user.name}さん`
    //     }
    //   }
    //   if (!str) {
    //     // str = "あなた"
    //   }
    //   return str
    // },

    // // 最初の台詞
    // first_talk_body() {
    //   let str = ""
    //   if (this.current_call_name) {
    //     str += `${this.current_call_name}の手番です`
    //   }
    //   return str
    // },
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
      // this.$nextTick(() => this.$refs.sp_vm.current_turn_set(0))  // 0手目の局面に戻す
      // this.$nextTick(() => this.$refs.sp_vm.api_board_turn_set(0))  // 0手目の局面に戻す
    },

    // 再挑戦
    restart_handle() {
      this.start_handle()
    },

    // 開始
    start_handle() {
      this.current_sfen_set()

      // オールラウンドの戦型選択
      this.cpu_strategy_random_number_reset()

      // 候補手クリア
      this.candidate_report = null
      this.candidate_rows = null

      // 評価グラフ
      this.chart_reset()

      // 投了を押せる状態にする
      this.give_up_processing = false

      // 開始
      this.mode = "playing"
      this.talk("よろしくお願いします")

      // 平手であれば振り駒
      if (this.preset_info.first_location_key === "black") {
        this.human_side_key = _.sample(Location.keys) // 振り駒をして
        if (this.human_side_key === "white") {        // 後手番なら
          this.flip = true                            // 盤面反転して
          this.$nextTick(() => this.one_hand_exec())  // 相手に初手を指させる
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
      this.play_mode_long_sfen_set(this.$refs.sp_vm.play_mode_current_sfen)
    },

    // 背景ランダム設定
    bg_variant_reset_handle() {
      while (true) {
        let v = _.sample(BG_VARIANT_AVAILABLE_LIST)
        if (this.bg_variant !== v) {
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
      }
      this.$buefy.dialog.alert(params)
    },

    view_mode_set() {
      this.mode = "standby"

      // standby にすると shogi-player を view_mode に切り替える
      // そのとき局面が0手目になってしまうので、最後の局面にする
      this.$nextTick(() => this.$refs.sp_vm.api_board_turn_set(10000))
      // this.$nextTick(() => this.$refs.sp_vm.current_turn_set(10000))
    },

    give_up_handle() {
      if (this.give_up_processing) {
        return
      }
      this.give_up_processing = true

      this.$http.post(this.$root.$options.post_path, {
        i_give_up: true,
      }).then(response => {
        this.response_process(response)
      }).catch(error => {
        this.error_process(error)
      })
    },

    play_mode_long_sfen_set(long_sfen) {
      if (this.mode === "standby") {
        return
      }
      this.$http.post(this.$root.$options.post_path, {
        kifu_body: long_sfen,
        cpu_brain_key: this.cpu_brain_key,
        cpu_strategy_key: this.cpu_strategy_key,
        cpu_strategy_random_number: this.cpu_strategy_random_number,
        cpu_preset_key: this.cpu_preset_key,
        yomiage_mode: this.yomiage_mode,
      }).then(response => {
        this.response_process(response)
      }).catch(error => {
        this.error_process(error)
      })
    },

    response_process(response) {
      const e = response.data
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

        this.candidate_report = e["candidate_report"]
        this.candidate_rows = e["candidate_rows"]

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
        if (data["irregular"]) {
          this.talk("反則負けです")
          this.easy_dialog({
            title: "反則負け",
            message: data["message"],
            type: "is-danger",
            hasIcon: true,
            icon: "times-circle",
            iconPack: "fa",
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

    error_process(error) {
      console.table([error.response])
      this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
    },
  },
}
</script>

<style lang="sass">
@import "./my_custom_buefy.scss"

.cpu_battle
  .candidate_report
    line-height: 100%
</style>
