<template lang="pug">
#app
  nav.navbar.is-transparent.is-primary
    .navbar-brand
      router-link.navbar-item(to="/")
        img(src="@/assets/logo.png" width="32")
        | Legacy Vue2 Based App
  .section
    .container.is-fluid
      router-view
</template>

<script>
export default {
  name: "App",
}
</script>

<style lang="sass">
</style>
