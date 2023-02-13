<template lang="pug">
.WkbkArticleIndexDetail
  .CustomShogiPlayerWrap
    .has-text-centered(v-if="article.direction_message")
      | {{article.direction_message}}
    CustomShogiPlayer(
      sp_mobile_vertical="is_mobile_vertical_off"
      sp_mode="view"
      :sp_body="article.init_sfen"
      :sp_viewpoint="article.viewpoint"
      :sp_turn="0"
      :sp_operation_disabled="true"
      )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleIndexDetail",
  mixins: [support_child],
  props: {
    article: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleIndexDetail
  width: 100%

  display: flex
  justify-content: center
  align-items: center
  flex-direction: column

  .CustomShogiPlayerWrap
    width: 100%
    +tablet
      padding-top: unset
      padding-bottom: unset
      max-width: 60vmin
</style>
