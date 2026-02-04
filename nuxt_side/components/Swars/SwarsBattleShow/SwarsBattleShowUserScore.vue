<template lang="pug">
span.SwarsBattleShowUserScore(:class="[TheShow.record.final_info.key, membership.judge_key]")
  template(v-if="development_p")
    span [{{TheShow.record.final_info.key}}]
    span [{{membership.judge_key}}]
  | {{membership.ek_score_without_cond}}点
</template>

<script>
export default {
  inject: ["TheShow"],
  props: {
    membership: { required: true },
  },
}
</script>

<style lang="sass">
.SwarsBattleShowUserScore
  &.ENTERINGKING
    &.win
      font-weight: bold
</style>
