<template lang="pug">
.modal-card.KomaochiSetModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 駒落ち設定

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    .buttons
      b-dropdown(v-model="base.komaochi_preset_key" position="is-bottom-right" @active-change="e => base.komaochi_preset_info_dropdown_active_change(e)")
        b-button(slot="trigger" icon-left="menu-down") 種類
        template(v-for="e in base.KomaochiPresetInfo.values")
          b-dropdown-item(@click="base.komaochi_preset_info_set_handle(e)") {{e.name}}
      b-button(@click="komaochi_henkou(-1)") ←
      b-button(@click="komaochi_henkou(1)") →

    //- CustomShogiPlayer(
    //-   :sp_body="base.komaochi_preset_info.sfen"
    //- )
    CustomShogiPlayer(
      sp_summary="is_summary_off"
      sp_run_mode="view_mode"
      :sp_sound_enabled="false"
      :sp_turn="0"
      :sp_body="base.komaochi_preset_info.sfen"
      :sp_viewpoint.sync="sp_viewpoint"
    )

    //- .buttons
    //-   b-button()

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.sync_button(@click="sync_handle" type="is-danger") 本当に転送する
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
      const info = this.base.KomaochiPresetInfo.fetch(this.base.komaochi_preset_key)
      const index = this.ruby_like_modulo(info.code + v, this.base.KomaochiPresetInfo.values.length)
      const next_info = this.base.KomaochiPresetInfo.fetch(index)
      this.base.komaochi_preset_key = next_info.key
    },

    cc_dropdown_active_change(on) {
      if (on) {
        this.sound_play("click")
      } else {
        this.sound_play("click")
      }
    },

    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    test_handle() {
      this.sound_play("click")
      this.base.force_sync("テスト転送")
    },
    sync_handle() {
      this.sound_play("click")
      this.base.force_sync_direct()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.KomaochiSetModal
  +tablet
    width: 40rem
  .modal-card-body
    padding: 1.5rem
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
