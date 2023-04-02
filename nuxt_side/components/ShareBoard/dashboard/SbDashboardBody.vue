<template lang="pug">
.SbDashboardBody
  b-loading(:active="$fetchState.pending")
  .BoxItems
    .BoxItem
      SbDashboardUserRanking(v-if="info")
    .BoxItem
      SbDashboardBattleIndex(v-if="info")
  pre(v-if="development_p && false") {{info}}
</template>

<script>
export default {
  name: "SbDashboardBody",
  props: {
    room_code: { type: String, required: true },
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
        room_code: this.room_code,
      },
    }).then(e => this.info = e)
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDashboardBody
  .title
    margin-top: 0rem
    margin-bottom: 0.5rem
    font-size: $size-5
  .BoxItems
    display: flex
    flex-wrap: wrap
    gap: 1rem
    .BoxItem
      flex-basis: 100%
      display: flex
      justify-content: center
      .box
        width: unquote("min(640px, 100%)")
        margin: 0
</style>
