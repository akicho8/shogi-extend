<template lang="pug">
.EmoxBattle
  EmoxRoomEmotion(:base="base")
  EmoxBattleVersus(:base="base")

  template(v-if="development_p")
    .buttons.is-centered.are-small
      b-button(@click="base.battle_unsubscribe") 切断(自分)
      b-button(@click="base.member_disconnect_handle(true)") 切断(相手)
</template>

<script>
import { support_child } from "../support_child.js"
import { up_down_scroll_disable } from "../../models/up_down_scroll_disable.js"

export default {
  name: "EmoxBattle",
  mixins: [
    support_child,
    up_down_scroll_disable,
  ],
  props: {
    base: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.EmoxBattle
  .vs_container
    justify-content: center
    align-items: center
</style>
