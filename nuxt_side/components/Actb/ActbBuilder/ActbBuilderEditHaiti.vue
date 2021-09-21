<template lang="pug">
.ActbBuilderEditHaiti.mt-4
  CustomShogiPlayer(
    sp_mobile_vertical="is_mobile_vertical_off"
    sp_run_mode="edit_mode"
    :sp_body="sp_body"
    :sp_turn="-1"
    sp_slider="is_slider_on"
    sp_controller="is_controller_on"
    :sp_sound_enabled="false"
    @update:edit_mode_snapshot_sfen="bapp.edit_mode_snapshot_sfen"
    ref="main_sp"
    )
  .footer_buttons
    .buttons.has-addons.is-centered.are-small.mt-3
      b-button(@click="$refs.main_sp.sp_object().mediator.shuffle_apply(3)") 3
      b-button(@click="$refs.main_sp.sp_object().mediator.shuffle_apply(4)") 4
      b-button(@click="$refs.main_sp.sp_object().mediator.shuffle_apply(5)") 5
      b-button(@click="$refs.main_sp.sp_object().mediator.shuffle_apply(6)") 6
      .ml-1
      b-button(icon-left="arrow-left"  @click="$refs.main_sp.sp_object().mediator.slide_xy(-1, 0)")
      b-button(icon-left="arrow-down"  @click="$refs.main_sp.sp_object().mediator.slide_xy(0, 1)")
      b-button(icon-left="arrow-up"    @click="$refs.main_sp.sp_object().mediator.slide_xy(0, -1)")
      b-button(icon-left="arrow-right" @click="$refs.main_sp.sp_object().mediator.slide_xy(1, 0)")

    .buttons.is-centered.are-small.is-marginless.mt-3
      PiyoShogiButton(:href="piyo_shogi_app_with_params_url" :icon_only="true")
      b-button(@click="$refs.main_sp.sp_object().mediator.king_formation_auto_set()") 玉
      KentoButton(tag="a" :href="kento_app_with_params_url" target="_blank" :icon_only="true")
      b-button(@click="$refs.main_sp.sp_object().mediator.king_formation_auto_unset()") 収
      KifCopyButton(@click="kifu_copy_handle") コピー
      b-button(tag="a" href="http://www.kukiminsho.com/tdb/searches/" target="_blank" size="is-small" v-if="development_p") 同

    .buttons.is-centered.are-small.is-marginless.mt-3
      b-button(@click="any_source_read_handle") 棋譜の読み込み

</template>

<script>
import { builder_support } from "./builder_support.js"

import ActbAnySourceReadModal from "../components/ActbAnySourceReadModal.vue"
import ActbSfenTrimModal   from "../components/ActbSfenTrimModal.vue"

export default {
  name: "ActbBuilderEditHaiti",
  mixins: [
    builder_support,
  ],
  data() {
    return {
      default_sp_body: null,
      sp_body: null,
    }
  },

  created() {
    // 更新した init_sfen が shogi-player の kifu_body に渡ると循環する副作用で駒箱が消えてしまうため別にする
    this.sp_body = this.bapp.question.init_sfen
    this.piece_box_piece_counts_adjust()
  },

  methods: {
    // 棋譜の読み込みタップ時の処理
    any_source_read_handle() {
      this.sound_play("click")
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        animation: "",
        component: ActbAnySourceReadModal,
        events: {
          "update:any_source": any_source => {
            this.sound_play("click")
            this.$axios.$post("/api/general/any_source_to.json", { any_source: any_source, to_format: "sfen" }).then(e => {
              modal_instance.close()
              if (this.sfen_parse(e.body).moves.length === 0) { // 元BODのSFEN
                this.toast_ok("反映しました")
                this.fixed_sfen_set(e.body)
              } else {
                // moves があるので局面を確定してもらう
                const sp_turn = this.turn_guess(any_source) // URLから現在の手数を推測
                this.fixed_sfen_confirm_handle({default_sp_body: e.body, sp_turn: sp_turn})
              }
            })
          },
        },
      })
    },

    // 棋譜の読み込みタップ時の処理
    fixed_sfen_confirm_handle(props) {
      this.toast_ok("局面を確定させてください")
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: props,
        animation: "",
        component: ActbSfenTrimModal,
        events: {
          "update:fixed_sfen": fixed_sfen => {
            this.sound_play("click")
            this.toast_ok("反映しました")
            this.fixed_sfen_set(fixed_sfen)
            modal_instance.close()
          },
        },
      })
    },

    // sp_body は常に今の状態を表わしているわけではない
    // 最初の状態しか入っていない
    // なので更新したと思っても最初の状態と変化していないので盤面に反映されない
    // こういうときは引数を渡して変化したかどうかとかそんなまわりくどいことはせずに
    // 直接更新すればいい
    fixed_sfen_set(str) {
      this.sp_body = str
      this.piece_box_piece_counts_adjust()
    },

    // 棋譜コピー
    kifu_copy_handle() {
      this.sound_play("click")
      this.general_kifu_copy(this.bapp.question.init_sfen, {to_format: "kif"})
    },

    // 駒箱に足りない駒を補充
    piece_box_piece_counts_adjust() {
      // this.$nextTick(() => this.$refs.main_sp.sp_object().mediator.piece_box_piece_counts_adjust())
    },

  },

  computed: {
    piyo_shogi_app_with_params_url() { return this.piyo_shogi_auto_url({sfen: this.bapp.question.init_sfen, turn: 0, viewpoint: "black"}) },
    kento_app_with_params_url()      { return this.kento_full_url({sfen: this.bapp.question.init_sfen, turn: 0, viewpoint: "black"}) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbBuilderEditHaiti
  .footer_buttons
    .button
      margin-bottom: 0
</style>
