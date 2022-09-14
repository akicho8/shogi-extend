<template lang="pug">
#app
  nav.navbar.is-transparent.is-dark
    .navbar-brand
      router-link.navbar-item(to="/")
        img(src="@/assets/logo.png" width="32")
        | 順番アルゴリズム検証
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
