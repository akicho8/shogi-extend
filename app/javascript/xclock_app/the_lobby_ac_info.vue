<template lang="pug">
.the_lobby_ac_info
  ul.is-flex.has-text-grey.is-size-7(v-if="app.debug_summary_p")
    li.ml-1(v-if="development_p")               購読{{app.ac_subscription_names}}
    li.ml-1(v-if="app.school_user_ids != null") オンライン{{app.school_user_ids.length}}人
    li.ml-1(v-if="app.matching_user_ids_hash")  対戦待ち{{app.matching_user_count}}人
    li.ml-1(v-if="app.room_user_ids != null")   対戦中{{app.room_user_ids.length}}人
    li.ml-1(v-if="development_p")               LRT:{{app.lobby_clock_mode_count}},{{app.lobby_clock_mode}}
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
  top: $xclock_primary_header_height
  left: 0
  right: 0
  ul
    justify-content: center
</style>
