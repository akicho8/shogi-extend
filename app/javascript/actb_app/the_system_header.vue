<template lang="pug">
.the_system_header.is-flex
  p(v-if="development_p")
    | 購読:{{app.ac_subscription_names}}
  p(v-if="app.online_user_ids != null")
    | オンライン:{{app.online_user_ids.length}}人
  p(v-if="app.matching_list_hash")
    | 対戦待ち:
    | {{app.matching_list_hash.marathon_rule.length}},
    | {{app.matching_list_hash.singleton_rule.length}},
    | {{app.matching_list_hash.hybrid_rule.length}}
    | 人
  p(v-if="app.room_user_ids != null")
    | 対戦中:{{app.room_user_ids.length}}人
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_system_header",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_system_header
  position: fixed
  top: $actb_primary_header_height
  left: 0
  right: 0
  justify-content: center
  p
    font-size: $size-7
    margin-left: 0.5rem
</style>
