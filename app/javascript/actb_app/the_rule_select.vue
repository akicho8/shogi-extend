<template lang="pug">
.the_rule_select
  ////////////////////////////////////////////////////////////////////////////////
  .primary_header
    b-icon.header_item.with_icon.ljust(icon="arrow-left" @click.native="app.rule_cancel_handle")
    .header_center_title ルール選択

  .buttons.is-centered.rule_buttons
    template(v-for="row in app.RuleInfo.values")
      template(v-if="row.display_p || development_p")
        b-button.has-text-weight-bold(@click="app.rule_key_set_handle(row)" :type="{'is-primary': app.matching_user_ids_hash[row.key].length >= 1}" expanded)
          | {{row.name}}
          template(v-if="app.debug_read_p")
            | ({{app.matching_user_ids_hash[row.key].length}})

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
      height: 3.75rem
      &:not(:first-child)
        margin-top: 0.3rem // ボタンとボタンの隙間
</style>
