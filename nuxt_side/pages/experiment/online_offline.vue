<template lang="pug">
.online_offline
  div
    | $nuxt.isOffline = {{$nuxt.isOffline}}
  div
    | $nuxt.isOnline = {{$nuxt.isOnline}}
  nuxt-link(:to="{name:'index'}" exact-active-class="is-active") TOP
</template>

<script>

export default {
  name: "online_offline",
}
</script>

<style lang="sass">
</style>
