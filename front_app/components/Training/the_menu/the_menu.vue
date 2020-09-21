<template lang="pug">
.the_menu
  the_footer
  component(:is="app.menu_component")
</template>

<script>
import { support }         from "../support.js"
import { background_grey } from "../background_grey.js"
import the_menu_root       from "./the_menu_root.vue"
import the_menu_etc        from "./the_menu_etc.vue"
import the_menu_sound      from "./the_menu_sound.vue"
import the_menu_debug      from "./the_menu_debug.vue"
import the_footer          from "../the_footer.vue"

export default {
  name: "the_menu",
  mixins: [
    support,
    background_grey,
  ],
  components: {
    the_menu_root,
    the_menu_etc,
    the_menu_sound,
    the_menu_debug,
    the_footer,
  },
  created() {
    this.app.menu_to("the_menu_root")
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_menu
  padding: $padding_top1 0.7rem $margin_bottom
  .menu_buttons
    margin-top: 1rem
    .button
      justify-content: flex-start
      height: 3.75rem
      &:not(:first-child)
        margin-top: 0.3rem // ボタンとボタンの隙間
    .field
      margin: 1rem 0.5rem
</style>
