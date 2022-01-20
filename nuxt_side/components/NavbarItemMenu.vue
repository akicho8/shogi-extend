<template lang="pug">
b-navbar-item.NavbarItemMenu.px_5_if_tablet.sidebar_toggle_navbar_item(
  v-bind="$attrs"
  v-on="$listeners"
  )
  b-icon(icon="menu")
</template>

<script>
export default {
  name: "NavbarItemMenu",
}
</script>
