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
import ActbFixedSfenConfirmModal   from "../components/ActbFixedSfenConfirmModal.vue"

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
                const sp_turn = this.sp_turn_guess(any_source) // URLから現在の手数を推測
                this.fixed_sfen_confirm_handle({default_sp_body: e.body, sp_turn: sp_turn})
              }
            })
          },
        },
      })
    },

    // https://www.kento-shogi.com/?branch=B%2A8b.9c8c.8b7c%2B.7b7c.5b8b%2B.8c7d.P%2A7e.7d6c.8b6b.6c5d.6b5b&branchFrom=120&moves=2g2f.3c3d.2f2e.2b3c.2h2f.8b2b.4i3h.3a4b.2f3f.2c2d.2e2d.2b2d.P%2A2g.5a6b.9g9f.9c9d.7i6h.6b7b.3i4h.7a8b.6i7i.8c8d.5i5h.8b8c.8h9g.7b8b.9g7e.6a7b.7e6f.4c4d.3f2f.P%2A2e.2f5f.4a5b.5f4f.4b4c.3g3f.5b6b.4h3g.6c6d.7g7f.1c1d.1g1f.6b6c.5h4h.7c7d.4h3i.8a7c.5g5f.2d2b.6h5g.2b4b.5f5e.5c5d.5e5d.4c5d.5g5f.P%2A5e.5f5e.5d5e.6f5e.S%2A4e.4f4e.4d4e.5e3c%2B.2a3c.B%2A5a.4b5b.5a3c%2B.5b5i%2B.3i2h.5i7i.N%2A5e.R%2A5i.S%2A3i.B%2A5g.S%2A4h.5g4h%2B.3g4h.5i6i%2B.5e6c%2B.7b6c.7f7e.N%2A5f.P%2A5i.5f4h%2B.3i4h.4e4f.7e7d.4f4g%2B.7d7c%2B.6c7c.3h4g.P%2A4f.4g4f.G%2A4i.P%2A7d.8c7d.N%2A8f.4i4h.8f7d.7i7d.P%2A7e.7d7e.B%2A8f.7e8f.8g8f.B%2A3i.2h1h.4h3h.R%2A5b.P%2A7b.S%2A7a.8b9c.N%2A8e.8d8e.3c6f.N%2A8d.6f3i.3h3i.B%2A8b.9c8c.8b7c%2B.7b7c.G%2A8b.8c7d.P%2A7e.7d7e.5b5e%2B.N%2A6e.P%2A7f.8d7f.G%2A6f.7e8f.6f7f.8f8g#118
    // のURLから変換するときは現在局面 118 に合わせておきたい
    // FIXME: 他の所でも使うなら現在の局面を表す手数の推測はAPI側に持っていく
    sp_turn_guess(str) {
      const md = str.match(/http.*kento.*#(\d+)/)
      if (md) {
        return parseInt(md[1])
      }
    },

    // 棋譜の読み込みタップ時の処理
    fixed_sfen_confirm_handle(props) {
      this.toast_ok("局面を確定させてください")
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: props,
        animation: "",
        component: ActbFixedSfenConfirmModal,
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
