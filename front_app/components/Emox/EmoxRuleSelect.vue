<template lang="pug">
.EmoxRuleSelect
  MainNavbar
    template(slot="brand")
      b-navbar-item(@click.native="base.rule_cancel_handle")
        b-icon(icon="chevron-left")
      b-navbar-item.has-text-weight-bold(tag="div") ルール選択
  MainSection
    .container
      .buttons.is-centered.rule_buttons.mt-0
        template(v-for="row in base.RuleInfo.values")
          b-button.has-text-weight-bold(@click="base.rule_key_set_handle(row)" expanded size="is-medium")
            | {{row.name}}
            div(v-if="user_count(row) >= 1 && development_p")
              b-tag(type="is-primary" rounded)
                | {{user_count(row)}}
  EmoxMatchingOperation(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "EmoxRuleSelect",
  mixins: [support_child],
  methods: {
    user_count(rule) {
      return (this.base.matching_user_ids_hash[rule.key] || []).length
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.EmoxRuleSelect
  .rule_buttons
    .button
      height: 5rem
      &:not(:first-child)
        margin-top: 0.5rem
</style>
