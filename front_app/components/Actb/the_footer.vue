<template lang="pug">
.the_footer.footer_nav.is-flex(:class="{hidden_p: hidden_p}")
  .item(@click="base.lobby_handle")
    b-icon(:icon="base.mode === 'lobby'    ? 'home'        : 'home-outline'"  :class="{'has-text-primary': base.mode === 'lobby'}")
  .item(@click="base.ranking_handle")
    b-icon(:icon="base.mode === 'ranking'  ? 'crown'       : 'crown-outline'" :class="{'has-text-primary': base.mode === 'ranking'}")
  .item(@click="base.history_handle")
    b-icon(:icon="base.mode === 'history'  ? 'history'     : 'history'"       :class="{'has-text-primary': base.mode === 'history'}")
  .item(@click="base.builder_handle")
    b-icon(:icon="base.mode === 'builder'  ? 'plus-thick'  : 'plus'"          :class="{'has-text-primary': base.mode === 'builder'}")
  .item(@click="base.menu_handle")
    b-icon(:icon="base.mode === 'menu'     ? 'menu'        : 'menu'"          :class="{'has-text-primary': base.mode === 'menu'}")

  b-dropdown(position="is-top-left" v-if="false")
    b-button(slot="trigger" icon-left="menu" @click="sound_play('click')")
    b-dropdown-item(@click="sound_play('click'); $router.push({name: 'index'})") TOP
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "the_footer",
  mixins: [
    support_child,
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
        if (this.base.config.footer_hidden_function) {
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
.ActbApp
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
