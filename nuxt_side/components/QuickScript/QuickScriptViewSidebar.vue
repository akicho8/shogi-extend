<template lang="pug">
b-sidebar.is-unselectable.QuickScriptViewSidebar(fullheight right overlay v-model="QS.sidebar_p" v-if="QS.params.sideber_menu_show")
  .mx-4.my-4
    .is-flex.is-justify-content-space-between.is-align-items-center
      b-button.px-5(@click="QS.sidebar_toggle" icon-left="menu")
    .mt-0
      b-menu
        template(v-for="e in QS.params.sideber_menu_groups")
          b-menu-list(:label="e.group_name")
            template(v-for="e in e.menu_items")
              b-menu-item.is_active_unset(v-bind="e")
</template>

<script>
export default {
  name: "QuickScriptViewSidebar",
  inject: ["QS"],
}
</script>

<style lang="sass">
.QuickScriptViewSidebar
  .sidebar-content
    a
      white-space: nowrap
    .menu-label
      margin-top: 2.5em
</style>
