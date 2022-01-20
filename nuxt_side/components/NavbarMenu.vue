<template lang="pug">
b-navbar-item.NavbarMenu.px_5_if_tablet.sidebar_toggle_navbar_item(
  v-bind="$attrs"
  v-on="$listeners"
  )
  b-icon(icon="menu")
</template>

<script>
export default {
  name: "NavbarMenu",
}
</script>
