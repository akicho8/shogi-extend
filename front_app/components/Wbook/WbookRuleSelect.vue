<template lang="pug">
.WbookRuleSelect
  ////////////////////////////////////////////////////////////////////////////////
  .primary_header
    b-icon.header_item.with_icon.ljust(icon="chevron-left" @click.native="base.rule_cancel_handle")
    .header_center_title ルール選択

  .buttons.is-centered.rule_buttons
    template(v-for="row in base.RuleInfo.values")
      template(v-if="rule_display_p(row)")
        b-button(@click="base.rule_key_set_handle(row)" :class="{'is_active': base.matching_user_ids_hash[row.key].length >= 1}" expanded)
          span.has-text-weight-bold
            | {{row.name}}
            template(v-if="base.debug_read_p")
              | (待:{{base.matching_user_ids_hash[row.key].length}})
          .description.is-size-8.has-text-grey.mt-1
            | {{row.description}}
          .has-text-primary(v-if="base.matching_user_ids_hash[row.key].length >= 1")
            b-icon(icon="account")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookRuleSelect",
  mixins: [
    support_child,
  ],
  methods: {
    rule_display_p(row) {
      if (this.development_p) {
        // return true
      }
      if (!this.base.practice_p) {
        if (row.practice_only) {
          return false
        }
      }
      if (!row.display_p) {
        return false
      }

      return true
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.WbookRuleSelect
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
        border-color: change_color($primary, $lightness: 70%)
        &:hover
          border-color: change_color($primary, $lightness: 50%)
      .icon
        position: absolute
        top: 0.35rem
        left: 0.9rem
</style>
