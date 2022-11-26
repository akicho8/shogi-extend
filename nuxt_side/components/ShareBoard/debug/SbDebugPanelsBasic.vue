<template lang="pug">
.SbDebugPanelsBasic.column.is-2
  .panel
    .panel-heading
      | 基本
    a.panel-block(@click="TheSb.room_create_by('dev_room', 'alice')") 入室
    a.panel-block(@click="TheSb.os_setup_by_names(['alice', 'bob', 'carol', 'dave', 'ellen'])") 順番設定
    a.panel-block(@click="TheSb.cc_play_by()") 時計開始
</template>

<script>
export default {
  name: "SbDebugPanelsBasic",
  inject: ["TheSb"],
  computed: {
    Howler() { return window.Howler },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanelsBasic
</style>
