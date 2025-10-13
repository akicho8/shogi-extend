<template lang="pug">
.KiwiLemonNewValidation.column.is-half(v-if="$GX.present_p(base.review_error_messages)")
  .panel.is-twitter(:class="base.review_error_messages_valid_p ? 'x-is-success' : 'x-is-danger'" size="is-small")
    .panel-heading
      | \#{{base.done_record.id}} Twitterアップロード条件
    .panel-block.is-flex-direction-column
      template(v-for="e in base.review_error_messages")
        .media
          .media-left
            b-icon(v-bind="e.icon_args")
          .media-content
            | {{e.should_be}}
          .media-right
            | {{e.human_value}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewValidation",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewValidation
  .media
    padding: 0.25rem
    margin: 0
    border: 0
    width: 100%
    &:hover
      background-color: $white-ter

  .panel-block
    padding: 0.5rem
</style>
