<template lang="pug">
.the_footer.footer_nav.is-flex(:class="{hidden_p: hidden_p}")
  .item(@click="app.lobby_handle")
    b-icon(:icon="app.mode === 'lobby'    ? 'home'        : 'home-outline'"  :class="{'has-text-primary': app.mode === 'lobby'}")
  .item(@click="app.ranking_handle")
    b-icon(:icon="app.mode === 'ranking'  ? 'crown'       : 'crown-outline'" :class="{'has-text-primary': app.mode === 'ranking'}")
  .item(@click="app.history_handle")
    b-icon(:icon="app.mode === 'history'  ? 'history'     : 'history'"       :class="{'has-text-primary': app.mode === 'history'}")
  .item(@click="app.builder_handle")
    b-icon(:icon="app.mode === 'builder'  ? 'plus-thick'  : 'plus'"          :class="{'has-text-primary': app.mode === 'builder'}")
  .item(@click="app.menu_handle")
    b-icon(:icon="app.mode === 'menu'     ? 'menu'        : 'menu'"          :class="{'has-text-primary': app.mode === 'menu'}")

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
      if (y >= 128) {
        const diff = y - (this._before_scroll_y || 0)
        if (this.app.config.footer_hidden_function) {
          this.hidden_p = (diff >= 1)
        }
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
    .item
      cursor: pointer

      padding-right: 1rem
      padding-left: 1rem
      height: inherit

      display: flex
      justify-content: center
      align-items: center

  transition: all 0.2s ease-out
  &.hidden_p
    transform: translateY($footer_height)
</style>
