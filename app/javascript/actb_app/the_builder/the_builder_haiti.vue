<template lang="pug">
.the_builder_haiti
  shogi_player(
    :run_mode="'edit_mode'"
    :kifu_body="$parent.fixed_init_sfen"
    :start_turn="-1"
    :slider_show="true"
    :controller_show="true"
    :setting_button_show="false"
    :theme="'simple'"
    :size="'default'"
    :sound_effect="false"
    :volume="0.5"
    @update:edit_mode_snapshot_sfen="$parent.edit_mode_snapshot_sfen"
    )
  .buttons.is-centered.footer_buttons
    b-button(@click="any_source_read_handle") 棋譜の読み込み
</template>

<script>
import { support } from "../support.js"
import any_source_read_modal from "../components/any_source_read_modal.vue"
import haiti_kimeru_modal from "../components/haiti_kimeru_modal.vue"
import SfenParser from "shogi-player/src/sfen_parser.js"

export default {
  name: "the_builder_haiti",
  mixins: [
    support,
  ],
  data() {
    return {
      yomikonda_sfen: null,
    }
  },

  methods: {
    // 棋譜の読み込みタップ時の処理
    any_source_read_handle() {
      this.sound_play("click")
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        animation: "",
        component: any_source_read_modal,
        events: {
          "update:any_source": any_source => {
            this.sound_play("click")
            this.remote_fetch("POST", "/api/general/any_source_to", { any_source: any_source, to_format: "sfen" }, e => {
              if (e.body) {
                modal_instance.close()

                const sfen_parser = SfenParser.parse(e.body)
                if (sfen_parser.moves.length === 0) { // BOD
                  // moves がないということは BOD とみなして即反映
                  this.general_ok_notice("反映しました")
                  this.$parent.fixed_init_sfen = e.body
                } else {
                  // moves があるので局面を確定してもらう
                  this.yomikonda_sfen = e.body
                  this.kyokumen_kimeru_handle()
                }
              }
            })
          },
        },
      })
    },
    // 棋譜の読み込みタップ時の処理
    kyokumen_kimeru_handle() {
      this.general_ok_notice("局面を確定させてください")
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: { yomikonda_sfen: this.yomikonda_sfen },
        animation: "",
        component: haiti_kimeru_modal,
        events: {
          "update:kyokumen_kimeta_sfen": kyokumen_kimeta_sfen => {
            this.sound_play("click")
            this.general_ok_notice("反映しました")
            this.$parent.fixed_init_sfen = kyokumen_kimeta_sfen
            this.$parent.edit_mode_snapshot_sfen(this.$parent.fixed_init_sfen) // 正解を削除するトリガーを明示的に実行
            modal_instance.close()
          },
        },
      })
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_haiti
  margin-top: 1.25rem
  .footer_buttons
    margin-top: 0.8rem
</style>
