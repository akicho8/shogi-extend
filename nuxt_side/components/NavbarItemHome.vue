<template lang="pug">
b-navbar-item(:tag="tag" :to="to" @click.native="sfx_click()" v-bind="$attrs" v-on="$listeners")
  b-icon(:icon="icon")
</template>

<script>
export default {
  name: "NavbarItemHome",
  props: {
    to:   { default: () => ({name: "index"}), },
    icon: { default: "home",                  },
    tag:  { default: "nuxt-link",             },
  },
}
</script>
