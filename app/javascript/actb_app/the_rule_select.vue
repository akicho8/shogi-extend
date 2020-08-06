<template lang="pug">
.the_rule_select
  ////////////////////////////////////////////////////////////////////////////////
  .primary_header
    b-icon.header_item.with_icon.ljust(icon="arrow-left" @click.native="app.rule_cancel_handle")
    .header_center_title ルール選択

  .buttons.is-centered.rule_buttons
    template(v-for="row in app.RuleInfo.values")
      template(v-if="row.time_range_active_p || app.practice_p || development_p")
        b-button(@click="app.rule_key_set_handle(row)" :class="{'is_active': app.matching_user_ids_hash[row.key].length >= 1}" expanded)
          //- :disabled="app.config.rule_time_enable && !app.practice_p && !row.time_range_active_p"
          span.has-text-weight-bold
            | {{row.name}}
            template(v-if="app.debug_read_p")
              | (待:{{app.matching_user_ids_hash[row.key].length}})
            //- template(v-if="app.config.rule_time_enable && row.time_range_active_p")
            //-   | ★
          .description.is-size-8.has-text-grey.mt-1
            | {{row.description}}
          //- .time_ranges.is-size-8.has-text-grey.mt-1.has-text-weight-bold(v-if="app.config.rule_time_enable")
          //-   template(v-for="range in row.raw_time_ranges")
          //-     span.mx-1
          //-       template(v-if="app.RuleInfo.time_range_active_p(range)")
          //-         span.has-text-danger
          //-           | {{range.beg}〜{{range.end}
          //-       template(v-else)
          //-         span
          //-           | {{range.beg}}〜{{range.end}}
          .has-text-primary(v-if="app.matching_user_ids_hash[row.key].length >= 1")
            b-icon(icon="account")
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
        border-color: change_color($primary, $lightness: 70%)
        &:hover
          border-color: change_color($primary, $lightness: 50%)
      .icon
        position: absolute
        top: 0.35rem
        left: 0.9rem
</style>
