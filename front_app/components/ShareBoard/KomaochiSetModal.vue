<template lang="pug">
.modal-card.KomaochiSetModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 手合割
    p
      template(v-if="base.komaochi_preset_info.handicap_level >= 1") +
      | {{base.komaochi_preset_info.handicap_level}}

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    .select_container
      b-select.komaochi_preset_key(v-model="base.komaochi_preset_key" @input="sound_play('click')")
        option(v-for="e in base.KomaochiPresetInfo.values" :value="e.key" v-text="e.name")

    .sp_container.mt-4
      CustomShogiPlayer(
        sp_summary="is_summary_off"
        sp_run_mode="view_mode"
        sp_mobile_vertical="is_mobile_vertical_off"
        sp_layout="is_horizontal"
        sp_pi_variant="is_pi_variant_b"
        :sp_hidden_if_piece_stand_blank="false"
        :sp_op_disabled="true"
        :sp_sound_enabled="false"
        :sp_turn="0"
        :sp_body="base.komaochi_preset_info.sfen"
      )
    .description_container.mt-4
      .description
        | {{base.komaochi_preset_info.description}}

    .buttons_container.buttons.has-addons.is-centered.mb-0.mt-4
      b-button.mb-0(@click="komaochi_henkou(-1)" icon-left="chevron-left")
      b-button.mb-0(@click="komaochi_henkou(1)" icon-left="chevron-right")

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.apply_button(@click="apply_handle" type="is-primary") 適用
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KomaochiSetModal",
  mixins: [
    support_child,
  ],
  methods: {
    komaochi_henkou(v) {
      this.sound_play("click")
      const i = this.base.komaochi_preset_info.code + v
      const new_index = this.ruby_like_modulo(i, this.base.KomaochiPresetInfo.values.length)
      const next = this.base.KomaochiPresetInfo.fetch(new_index)
      this.base.komaochi_preset_key = next.key
    },
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    apply_handle() {
      this.sound_play("click")
      this.base.force_sync_komaochi()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.KomaochiSetModal
  +tablet
    width: 32rem
  .modal-card-body
    padding: 1.25rem
    .select_container
      display: flex
      justify-content: center
    .sp_container
      display: flex
      justify-content: center
    .description_container
      display: flex
      justify-content: center
      //- .description
    //- width: 20rem
    .buttons_container
      .button
        min-width: 8rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold

  .CustomShogiPlayer
    width: 16rem
    --sp_board_padding: 0
    --sp_board_color: transparent
    --sp_shadow_offset: 0
    --sp_shadow_blur: 0
    --sp_grid_outer_stroke: 0
    --sp_grid_outer_color: hsl(0, 0%, 80%)
    --sp_grid_color:       hsl(0, 0%, 80%)
    --sp_stand_piece_w: 22px
    --sp_stand_piece_h: 22px

.STAGE-development
  .KomaochiSetModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    // .CustomShogiPlayer
    //   border: 1px dashed change_color($danger, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
