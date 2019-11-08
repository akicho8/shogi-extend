<template lang="pug">
.cpu_battle
  .columns
    .column
      .has-text-centered
        shogi_player(
          :kifu_body="full_sfen"
          :theme="sp_params.theme"
          :piece_variant="sp_params.piece_variant"
          :key_event_capture="false"
          :slider_show="false"
          :sfen_show="false"
          :controller_show="true"
          :size="'x-large'"
          :sound_effect="true"
          :volume="$root.$options.volume"
          :run_mode="'play_mode'"
          :human_side="'black'"
          @update:play_mode_long_sfen="play_mode_long_sfen_set"
        )
    .column
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
            template(v-for="e in CpuStrategy2Info.values")
              b-radio(v-model="cpu_strategy2_key" :native-value="e.key" size="is-small")
                | {{e.name}}
      .box
        b-field(label="スタイル" custom-class="is-small")
          .block
            template(v-for="e in BoardStyleInfo.values")
              b-radio(v-model="sp_params.board_style_key" :native-value="e.key"  size="is-small")
                | {{e.name}}

      b-button(type="is-primary" @click="reset_handle")
        | 再挑戦

</template>

<script>
import _ from "lodash"
import CpuBrainInfo from "cpu_brain_info"
import CpuStrategyInfo from "cpu_strategy_info"
import CpuStrategy2Info from "cpu_strategy2_info"
import BoardStyleInfo from "board_style_info"

export default {
  name: "cpu_battle",
  data() {
    return {
      full_sfen: null,
      sp_params: this.$root.$options.sp_params,
      current_user: js_global.current_user, // 名前を読み上げるため

      cpu_brain_key: this.$root.$options.cpu_brain_key,
      cpu_strategy_key: this.$root.$options.cpu_strategy_key,
      cpu_strategy2_key: this.$root.$options.cpu_strategy2_key,
    }
  },

  created() {
    CpuBrainInfo.memory_record_reset(this.$root.$options.cpu_brain_infos)
    CpuStrategyInfo.memory_record_reset(this.$root.$options.cpu_strategy_infos)
    CpuStrategy2Info.memory_record_reset(this.$root.$options.cpu_strategy2_infos)

    this.board_style_info_reflection()

    this.reset()
  },

  computed: {
    CpuBrainInfo()    { return CpuBrainInfo    },
    CpuStrategyInfo() { return CpuStrategyInfo },
    CpuStrategy2Info() { return CpuStrategy2Info },
    BoardStyleInfo()  { return BoardStyleInfo  },

    board_style_info()  { return BoardStyleInfo.fetch(this.sp_params.board_style_key) },
    cpu_brain_info()    { return CpuBrainInfo.fetch(this.cpu_brain_key)               },
    cpu_strategy_info() { return CpuStrategyInfo.fetch(this.cpu_strategy_key)         },
    cpu_strategy2_info() { return CpuStrategy2Info.fetch(this.cpu_strategy2_key)         },

    // 対戦者の名前
    current_call_name() {
      let str = null
      if (!str) {
        if (this.current_user) {
          str = `${this.current_user.name}さん`
        }
      }
      if (!str) {
        // str = "あなた"
      }
      return str
    },

    // 最初の台詞
    first_talk_body() {
      let str = "よろしくお願いします。"
      if (this.current_call_name) {
        str += `${this.current_call_name}のてばんです`
      }
      return str
    },
  },

  watch: {
    cpu_brain_key() {
      this.talk(`${this.cpu_brain_info.name}に変更しました`)
    },

    cpu_strategy_key() {
      this.talk(`${this.cpu_strategy_info.name}に変更しました`)
    },

    cpu_strategy2_key() {
      this.talk(`${this.cpu_strategy2_info.name}に変更しました`)
    },

    // 盤面
    "sp_params.board_style_key": function() {
      this.board_style_info_reflection()
      this.talk(`${this.board_style_info.name}に変更しました`)
    },
  },

  methods: {
    reset() {
      this.full_sfen = "position startpos"
      setTimeout(() => this.talk(this.first_talk_body), 1000 * 0)
    },

    reset_handle() {
      this.reset()
    },

    board_style_info_reflection() {
      this.board_style_info.func(this.sp_params)
    },

    play_mode_long_sfen_set(v) {
      this.$http.post(this.$root.$options.player_mode_moved_path, {
        kifu_body: v,
        cpu_brain_key: this.cpu_brain_key,
        cpu_strategy_key: this.cpu_strategy_key,
        cpu_strategy2_key: this.cpu_strategy2_key,
      }).then(response => {
        if (response.data["error_message"]) {
          this.$buefy.dialog.alert({
            title: "反則負け",
            message: response.data["error_message"],
            type: 'is-danger',
            hasIcon: true,
            icon: 'times-circle',
            iconPack: 'fa',
          })
          this.talk("反則負けです")

          // this.$buefy.dialog.alert({
          //   message: response.data["normal_message"],
          // })

        }

        if (response.data["you_win_message"]) {
          // this.$buefy.toast.open({message: response.data["normal_message"], position: "is-bottom", type: "is-info", duration: 1000 * 10})

          this.$buefy.dialog.alert({
            title: "勝利",
            message: response.data["you_win_message"],
            type: 'is-primary',
            hasIcon: true,
            icon: 'trophy',
            iconPack: 'mdi',
          })
          this.talk("勝ちました")
        }

        if (response.data["you_lose_message"]) {
          // this.$buefy.toast.open({message: response.data["normal_message"], position: "is-bottom", type: "is-info", duration: 1000 * 10})

          this.$buefy.dialog.alert({
            title: "敗北",
            message: response.data["you_lose_message"],
            type: 'is-primary',
          })
          this.talk("負けました")
        }

        // CPUの指し手を読み上げる
        if (response.data["yomiage"]) {
          this.talk(response.data["yomiage"])
        }

        if (response.data["sfen"]) {
          this.full_sfen = response.data["sfen"]
        }

      }).catch(error => {
        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },
}
</script>

<style lang="sass">
@import "./my_custom_buefy.scss"

.cpu_battle
</style>
