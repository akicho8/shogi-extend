<template lang="pug">
.WbookLobbyAcInfo
  ul.is-flex.has-text-grey.is-size-7(v-if="base.debug_summary_p")
    li.ml-1(v-if="development_p")               購読{{base.ac_subscription_names}}
    li.ml-1(v-if="base.school_user_ids != null") オンライン{{base.school_user_ids.length}}人
    li.ml-1(v-if="base.matching_user_ids_hash")  対戦待ち{{base.matching_user_count}}人
    li.ml-1(v-if="base.room_user_ids != null")   対戦中{{base.room_user_ids.length}}人
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookLobbyAcInfo",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.WbookLobbyAcInfo
  position: fixed
  top: $wbook_primary_header_height
  left: 0
  right: 0
  ul
    justify-content: center
</style>
