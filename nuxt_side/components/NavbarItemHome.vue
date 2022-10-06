<template lang="pug">
b-navbar-item(tag="nuxt-link" :to="to" @click.native="$sound.play_click()")
  b-icon(:icon="icon")
</template>

<script>
export default {
  name: "NavbarItemHome",
  props: {
    to:   { default: () => ({name: "index"}), },
    icon: { default: "home",                  },
  },
}
</script>
