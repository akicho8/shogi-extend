<template lang="pug">
b-sidebar.WkbkBookIndexSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .is-flex.is-justify-content-start.is-align-items-center.ml-4.mt-4
    b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
  WkbkBookIndexSidebarBody(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookIndexSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookIndexSidebar
</style>
