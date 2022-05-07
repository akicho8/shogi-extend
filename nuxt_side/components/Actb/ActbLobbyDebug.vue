<template lang="pug">
.ActbLobbyDebug.box(v-if="base.debug_write_p")
  .buttons.are-small
    template(v-for="row in base.RuleInfo.values")
      b-button(@click="base.debug_matching_add_handle(row)") 自分以外を{{row.name}}に参加させる
    b-button(@click="base.matching_users_clear_handle") 全員解散
    b-button(@click="base.new_challenge_accept_handle({rule_key: 'test_rule', user: {id:1,name:'user1'}})") マッチングの人と直接対戦する
    b-button(@click="base.new_challenge_notify({rule_key: 'test_rule', user: {id:1,name:'user1'}, duration: 1000*60*60})") マッチングを開始した人がいる通知
    b-button(@click="base.new_challenge_notify({rule_key: 'test_rule', user: {id:1,name:'user1'}, duration: 1000})") マッチングを開始した人がいる通知(1秒)
    b-button(@click="base.new_challenge_snackbar_clear") 挑戦者登場snackbar消去({{base.snackbar_instances.length}})
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ActbBuilderApp",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.ActbLobbyDebug
  .image
    img
</style>
