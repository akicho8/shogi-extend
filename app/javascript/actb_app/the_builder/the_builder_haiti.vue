<template lang="pug">
.the_builder_haiti
  shogi_player(
    :run_mode="'edit_mode'"
    :kifu_body="new_kifu_body"
    :start_turn="-1"
    :slider_show="true"
    :controller_show="true"
    :setting_button_show="false"
    :theme="'simple'"
    :size="'default'"
    :sound_effect="false"
    :volume="0.5"
    @update:edit_mode_snapshot_sfen="$parent.edit_mode_snapshot_sfen"
    ref="main_sp"
    )
  .footer_buttons
    .buttons.is-centered.are-small.is-marginless.mt-3
      piyo_shogi_button(:href="piyo_shogi_app_with_params_url")
      kento_button(tag="a" :href="kento_app_with_params_url" target="_blank")
      kif_copy_button(@click="kifu_copy_handle") コピー
    .buttons.is-centered.are-small.is-marginless.mt-3
      b-button(icon-left="upload" @click="any_source_read_handle") 棋譜の読み込み
</template>

<script>
import { support } from "../support.js"
import any_source_read_modal from "../components/any_source_read_modal.vue"
import haiti_kimeru_modal from "../components/haiti_kimeru_modal.vue"

export default {
  name: "the_builder_haiti",
  mixins: [
    support,
  ],
  data() {
    return {
      yomikonda_sfen: null,
      new_kifu_body: null,
    }
  },

  created() {
    // 更新した init_sfen が shogi-player の kifu_body に渡ると循環する副作用で駒箱が消えてしまうため別にする
    this.new_kifu_body = this.$parent.question.init_sfen
    this.piece_box_piece_couns_adjust()
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
              modal_instance.close()

              if (this.sfen_parse(e.body).moves.length === 0) { // 元BODのSFEN
                this.general_ok_notice("反映しました")
                this.kyokumen_set(e.body)
              } else {
                // moves があるので局面を確定してもらう
                this.yomikonda_sfen = e.body
                this.kyokumen_kimeru_handle()
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
            this.kyokumen_set(kyokumen_kimeta_sfen)
            modal_instance.close()
          },
        },
      })
    },

    // new_kifu_body は常に今の状態を表わしているわけではない
    // 最初の状態しか入っていない
    // なので更新したと思っても最初の状態と変化していないので盤面に反映されない
    // こういうときは引数を渡して変化したかどうかとかそんなまわりくどいことはせずに
    // 直接更新すればいい
    kyokumen_set(str) {
      this.$refs.main_sp.api_sfen_or_kif_set(str)
      this.piece_box_piece_couns_adjust()
    },

    // 棋譜コピー
    kifu_copy_handle() {
      this.sound_play("click")
      this.general_kifu_copy(this.$parent.question.init_sfen, {to_format: "kif"})
    },

    // 駒箱に足りない駒を補充
    piece_box_piece_couns_adjust() {
      this.$nextTick(() => this.$refs.main_sp.mediator.piece_box_piece_couns_adjust())
    },
  },

  computed: {
    piyo_shogi_app_with_params_url() { return this.piyo_shogi_auto_url({sfen: this.$parent.question.init_sfen, turn: 0, flip: false}) },
    kento_app_with_params_url()      { return this.kento_full_url({sfen: this.$parent.question.init_sfen, turn: 0, flip: false}) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_haiti
  margin-top: 1.25rem
  .footer_buttons
    .button
      margin-bottom: 0
</style>
