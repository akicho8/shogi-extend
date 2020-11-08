<template lang="pug">
.ActbMenuApp
  ActbFooter(:base="base")
  component(:base="base" :is="base.menu_component")
</template>

<script>
import { support_child }         from "../support_child.js"

import ActbMenuRoot  from "./ActbMenuRoot.vue"
import ActbMenuDebug from "./ActbMenuDebug.vue"
import ActbMenuEtc   from "./ActbMenuEtc.vue"

export default {
  name: "ActbMenuApp",
  mixins: [
    support_child,
  ],
  components: {
    ActbMenuRoot,
    ActbMenuDebug,
    ActbMenuEtc,
  },
  created() {
    this.base.menu_to("ActbMenuRoot")
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbMenuApp
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
