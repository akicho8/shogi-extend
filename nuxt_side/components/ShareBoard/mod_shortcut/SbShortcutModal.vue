<template lang="pug">
.modal-card.has-text-left(@click="SB.shortcut_modal_close_handle" style="width:auto")
  .modal-card-head
    .modal-card-title ショートカット
  .modal-card-body
    .columns.is-multiline.is-variable.is-0-mobile.is-3-tablet.is-3-desktop.is-3-widescreen.is-3-fullhd
      //- https://bulma.io/documentation/columns/responsiveness/
      //- .is-one-third-widescreen
      template(v-for="shortcut_category_info in SB.ShortcutCategoryInfo.values")
        .column.is-half-tablet.is-half-desktop(v-if="shortcut_category_info.showable_p(SB)")
          .sc_title {{shortcut_category_info.name}}
          .sc_table
            template(v-for="shortcut_info in shortcut_category_info.shortcut_infos")
              .sc_item(v-if="shortcut_info.showable_p(SB)")
                .sc_label {{shortcut_info.name}}
                .sc_buttons
                  template(v-for="value in shortcut_info.trigger_keys")
                    b-tag(type="is-primary") {{value}}
  .modal-card-foot
    b-button.shortcut_modal_close_handle(@click="SB.shortcut_modal_close_handle" icon-left="chevron-left")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbShortcutModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.SbShortcutModal
  +modal_max_width(512px)

  ////////////////////////////////////////////////////////////////////////////////

  padding: 1rem
  +mobile
    padding: 1rem
    .columns
      margin: 0
    .column
      padding: 0
      &:not(:first-child)
        margin-top: 0.75rem

  ////////////////////////////////////////////////////////////////////////////////

  .columns
    overflow-y: scroll
    font-size: $size-7
    .column
      .sc_title
        font-weight: bold
        margin-top: 0rem
        border-bottom: 1px solid $grey-lighter
        +mobile
          margin-top: 1.2rem
      .sc_table
        margin-top: 0.25rem
        .sc_item
          display: flex
          align-items: center
          justify-content: space-between
          padding: 0.15rem 0
          .sc_label
            font-weight: normal
            font-size: $size-7
          .sc_buttons
            display: flex
            align-items: center
            justify-content: flex-start
            gap: 0.25rem
            .tag
              font-weight: bold

  ////////////////////////////////////////////////////////////////////////////////

.STAGE-development
  .SbShortcutModal
    .columns
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
    table
      border: 1px dashed change_color($danger, $alpha: 0.5)
    td
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
