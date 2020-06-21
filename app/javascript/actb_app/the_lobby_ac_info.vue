<template lang="pug">
.the_lobby_ac_info
  .container.is-flex.has-text-grey.is-size-7
    .element(v-if="development_p")
      | 購読{{app.ac_subscription_names}}
    .element(v-if="app.online_user_ids != null")
      | オンライン
      .count {{app.online_user_ids.length}}
      | 人
    .element(v-if="app.matching_list_hash")
      | 対戦待ち
      .count
        | {{app.matching_list_hash.marathon_rule.length}},
        | {{app.matching_list_hash.singleton_rule.length}},
        | {{app.matching_list_hash.hybrid_rule.length}}
      | 人
    .element(v-if="app.room_user_ids != null")
      | 対戦中
      .count {{app.room_user_ids.length}}
      | 人
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_lobby_ac_info",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby_ac_info
  position: fixed
  top: $actb_primary_header_height
  left: 0
  right: 0
  .container
    justify-content: center
    margin-top: 0.1rem
    .element
      margin-left: 0.5rem
      .count
        display: inline
</style>
