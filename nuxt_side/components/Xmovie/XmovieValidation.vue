<template lang="pug">
.XmovieValidation.column.is-half(v-if="present_p(base.review_error_messages)")
  .panel(:class="base.review_error_messages_valid_p ? 'is-success' : 'is-danger'" size="is-small")
    .panel-heading
      | Twitterアップロード条件
    .panel-block
      ul
        template(v-for="e in base.review_error_messages")
          li
            template(v-if="e.valid_p")
              b-icon.mx-2(icon="check" type="is-success")
            template(v-else)
              b-icon.mx-2(icon="alert" type="is-danger")
            span {{e.should_be}} → {{e.human_value}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieValidation",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieValidation
  .panel-block
    padding: 0.5rem
    ul
      width: 100%
    li
      display: flex
      align-items: center
      line-height: 2.5rem

.STAGE-development
  .XmovieValidation
    li
      &:hover
        background-color: $white-ter
</style>
