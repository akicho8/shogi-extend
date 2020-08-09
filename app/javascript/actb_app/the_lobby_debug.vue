<template lang="pug">
.the_lobby_debug.box(v-if="app.debug_write_p")
  .buttons.are-small
    template(v-for="row in app.RuleInfo.values")
      b-button(@click="app.debug_matching_add_handle(row)") 自分以外を{{row.name}}に参加させる
    b-button(@click="app.matching_users_clear_handle") 全員解散
    b-button(@click="app.battle_request_accept_handle") マッチングの人と直接対戦する
    b-button(@click="app.new_challenger_snackbar('ルール1')") マッチングを開始した人がいる通知
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby_debug
</style>
