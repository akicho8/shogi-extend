<template lang="pug">
.WbookMenuApp
  WbookFooter(:base="base")
  component(:base="base" :is="base.menu_component")
</template>

<script>
import { support_child }         from "../support_child.js"

import WbookMenuRoot  from "./WbookMenuRoot.vue"
import WbookMenuDebug from "./WbookMenuDebug.vue"
import WbookMenuEtc   from "./WbookMenuEtc.vue"

export default {
  name: "WbookMenuApp",
  mixins: [
    support_child,
  ],
  components: {
    WbookMenuRoot,
    WbookMenuDebug,
    WbookMenuEtc,
  },
  created() {
    this.base.menu_to("WbookMenuRoot")
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WbookMenuApp
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
