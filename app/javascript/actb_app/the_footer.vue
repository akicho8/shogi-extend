<template lang="pug">
.the_footer.footer_nav.is-flex(:class="{hidden_p: hidden_p}")
  b-button(icon-left="home-outline"   @click="app.lobby_handle"   :type="{'is-primary': app.mode === 'lobby'}")
  b-button(icon-left="crown-outline"  @click="app.ranking_handle" :type="{'is-primary': app.mode === 'ranking'}")
  b-button(icon-left="note-outline"   @click="app.history_handle" :type="{'is-primary': app.mode === 'history'}" :disabled="!app.current_user")
  b-button(icon-left="database-plus"  @click="app.builder_handle" :type="{'is-primary': app.mode === 'builder'}" :disabled="!app.current_user")
  b-button(icon-left="menu"           @click="app.menu_handle"    :type="{'is-primary': app.mode === 'menu'}")

  b-dropdown(position="is-top-left" v-if="false")
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
  data() {
    return {
      hidden_p: false,
    }
  },
  mounted() {
    window.addEventListener('scroll', this.scroll_handle)
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.scroll_handle)
  },
  methods: {
    scroll_handle(e) {
      const y = window.scrollY
      if (y >= 256) {
        const diff = y - (this._before_scroll_y || 0)
        this.hidden_p = (diff >= 1)
      }
      this._before_scroll_y = y
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_footer
  &.footer_nav
    border-top: 1px solid $grey-lighter
    background-color: change_color($white-ter, $alpha: 0.96)

  transition: all 0.2s ease-out
  &.hidden_p
    transform: translateY($footer_height)
</style>
