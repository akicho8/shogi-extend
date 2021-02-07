<template lang="pug">
b-sidebar.WkbkArticleIndexSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .is-flex.is-justify-content-start.is-align-items-center.ml-5.mt-5
    b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
  WkbkArticleIndexSidebarBody(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleIndexSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleIndexSidebar
</style>
