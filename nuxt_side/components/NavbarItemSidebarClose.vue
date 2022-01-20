<template lang="pug">
b-button.NavbarItemSidebarClose.px-5.sidebar_close_handle(
  icon-left="menu"
  v-bind="$attrs"
  v-on="$listeners"
)
</template>

<script>
export default {
  name: "NavbarItemSidebarClose",
}
</script>
