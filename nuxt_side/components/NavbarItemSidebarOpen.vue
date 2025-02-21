<template lang="pug">
b-navbar-item.NavbarItemSidebarOpen.mobile_then_padding_add.px_5_if_tablet.sidebar_toggle_navbar_item(
  v-bind="$attrs"
  v-on="$listeners"
  )
  b-icon(icon="menu")
</template>

<script>
export default {
  name: "NavbarItemSidebarOpen",
}
</script>
