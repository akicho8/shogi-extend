<template lang="pug">
.the_footer.footer_nav.is-flex
  b-button(icon-left="home-outline"   @click="app.lobby_handle"   :type="{'is-primary': app.mode === 'lobby'}"   )
  b-button(icon-left="crown-outline"  @click="app.ranking_handle" :type="{'is-primary': app.mode === 'ranking'}" )

  template(v-if="app.current_user")
    b-button(icon-left="note-outline"   @click="app.history_handle" :type="{'is-primary': app.mode === 'history'}" )
    b-button(icon-left="wrench-outline" @click="app.builder_handle" :type="{'is-primary': app.mode === 'builder'}" )

  b-dropdown(position="is-top-left")
    b-button(slot="trigger" icon-left="menu" @click="sound_play('click')")
    b-dropdown-item(href="/" @click="sound_play('click')") TOP
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_footer",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_footer
  &.footer_nav
    border-top: 1px solid $grey-lighter
    background-color: change_color($white-ter, $alpha: 0.96)
</style>
