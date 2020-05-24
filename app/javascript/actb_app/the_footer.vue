<template lang="pug">
.the_footer.is-flex
  b-button(icon-left="home-outline"   @click="app.lobby_handle"   :type="{'is-primary': app.mode === 'lobby'}"   )
  b-button(icon-left="crown-outline"  @click="app.ranking_handle" :type="{'is-primary': app.mode === 'ranking'}" )
  b-button(icon-left="note-outline"   @click="app.history_handle" :type="{'is-primary': app.mode === 'history'}" )
  b-button(icon-left="wrench-outline" @click="app.builder_handle" :type="{'is-primary': app.mode === 'builder'}" )

  b-dropdown(position="is-top-left")
    b-button(slot="trigger" icon-left="menu" @click="sound_play('click')")
    b-dropdown-item(href="/") TOP
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_footer",
  mixins: [
    support,
  ],
  mounted() {
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_footer
  z-index: 1

  position: fixed
  left: 0
  bottom: 0

  border-top: 1px solid $grey-lighter
  background: change_color($white-ter, $alpha: 0.96)

  height: 64px
  width: 100%

  padding: 0 16px

  justify-content: space-between
  align-items: center
</style>
