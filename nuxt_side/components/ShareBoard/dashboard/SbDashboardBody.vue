<template lang="pug">
.SbDashboardBody
  b-loading(:active="$fetchState.pending")
  .BoxItems
    SbDashboardUserRanking(v-if="info")
    SbDashboardBattleIndex(v-if="info")
    .box(v-if="development_p")
      pre {{info}}
</template>

<script>
export default {
  name: "SbDashboardBody",
  props: {
    room_key: { type: String, required: true },
  },
  provide() {
    return {
      TheDb: this,
    }
  },
  data() {
    return {
      info: null,
    }
  },
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get("/api/share_board/dashboard", {
      params: {
        room_key: this.room_key,
      },
    }).then(e => this.info = e)
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDashboardBody
  pre
    white-space: pre-wrap
    word-break: break-all
  .title
    margin-top: 0rem
    margin-bottom: 0.5rem
    font-size: $size-5
  .BoxItems
    display: flex
    align-items: center
    flex-direction: column
    gap: 1rem
    .box
      width: unquote("min(640px, 100%)")
      margin: 0
</style>
