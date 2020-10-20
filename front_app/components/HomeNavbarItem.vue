<template lang="pug">
  b-navbar-item(tag="nuxt-link" :to="to" @click.native="sound_play('click')")
    b-icon(:icon="icon")
</template>

<script>
export default {
  name: "HomeNavbarItem",
  props: {
    to:   { default: { name: "index" }, },
    icon: { default: "home",            },
  },
}
</script>
