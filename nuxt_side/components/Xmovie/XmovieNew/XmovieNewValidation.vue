<template lang="pug">
.XmovieNewValidation.column.is-half(v-if="present_p(base.review_error_messages)")
  .panel.is-twitter(:class="base.review_error_messages_valid_p ? 'x-is-success' : 'x-is-danger'" size="is-small")
    .panel-heading
      | Twitterアップロード条件
    .panel-block
      ul
        template(v-for="e in base.review_error_messages")
          li
            b-icon.mx-2(v-bind="e.icon_args")
            span {{e.should_be}} → {{e.human_value}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieNewValidation",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieNewValidation
  .panel-block
    padding: 0.5rem
    ul
      width: 100%
    li
      display: flex
      align-items: center
      line-height: 2.5rem

.STAGE-development
  .XmovieNewValidation
    li
      &:hover
        background-color: $white-ter
</style>
