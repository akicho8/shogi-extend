<template lang="pug">
b-sidebar.KiwiBananaIndexSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .is-flex.is-justify-content-start.is-align-items-center.ml-4.mt-4
    NavbarItemSidebarClose(@click="base.sidebar_toggle")
  KiwiBananaIndexSidebarBody(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaIndexSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaIndexSidebar
  __css_keep__: 0
</style>
