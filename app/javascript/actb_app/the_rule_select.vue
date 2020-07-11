<template lang="pug">
.the_rule_select
  ////////////////////////////////////////////////////////////////////////////////
  .primary_header
    b-icon.header_item.with_icon.ljust(icon="arrow-left" @click.native="app.rule_cancel_handle")
    .header_center_title ルール選択

  .buttons.is-centered.rule_buttons
    template(v-for="row in app.RuleInfo.values")
      template(v-if="row.display_p || development_p")
        b-button(@click="app.rule_key_set_handle(row)" :class="{'is_active': app.matching_user_ids_hash[row.key].length >= 0}" expanded)
          span.has-text-weight-bold
            | {{row.name}}
            template(v-if="app.debug_read_p")
              | ({{app.matching_user_ids_hash[row.key].length}})
          .description.is-size-8.has-text-grey-light.mt-1
            | {{row.description}}

</template>

<script>
import { support } from "./support.js"
import { background_grey } from "./background_grey.js"

export default {
  name: "the_rule_select",
  mixins: [
    support,
    background_grey,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_rule_select
  padding: $padding_top1 0.7rem $margin_bottom
  // background-color: $white-ter

  .rule_buttons
    margin-top: 1rem
    flex-direction: column
    .button
      height: 4.75rem
      &:not(:first-child)
        margin-top: 0.3rem // ボタンとボタンの隙間
      &.is_active
        border: 1px solid change_color($primary, $lightness: 70%)
        &:hover
          border: 1px solid change_color($primary, $lightness: 50%)
</style>
