<template lang="pug">
.EmoxRuleSelect
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" @click="base.rule_cancel_handle")
      b-navbar-item.has-text-weight-bold(tag="div") ルール選択
  MainSection
    .container
      .columns
        .column
          .buttons.is-centered.rule_buttons
            template(v-for="row in base.RuleInfo.values")
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
import { support } from "./support.js"

export default {
  name: "EmoxRuleSelect",
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.EmoxRuleSelect
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
