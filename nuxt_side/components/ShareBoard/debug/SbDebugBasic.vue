<template lang="pug">
.SbDebugBasic.column.is-2
  .panel
    .panel-heading
      | 基本
    a.panel-block(@click="SB.room_create_from_modal('dev_room', 'alice')") 入室
    a.panel-block(@click="SB.os_setup_by_names(['alice', 'bob', 'carol', 'dave', 'ellen'])") 順番設定
    a.panel-block(@click="SB.cc_play_by()") 時計開始
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugBasic",
  mixins: [support_child],
  computed: {
    Howler() { return window.Howler },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugBasic
  __css_keep__: 0
</style>
