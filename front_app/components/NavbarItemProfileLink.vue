<template lang="pug">
b-navbar-item.NavbarItemProfileLink(
  v-if="new_user"
  tag="nuxt-link"
  :to="{name: 'users-id', params: {id: new_user.id}}"
  :title="new_user.name"
  @click.native="sound_play('click')"
  )
  .image
    img.is-rounded(:src="new_user.avatar_path" :alt="new_user.name")
</template>

<script>
export default {
  name: "NavbarItemProfileLink",
  props: {
    user: { type: Object, default: null },
  },
  computed: {
    new_user() {
      return this.user || this.g_current_user
    },
  },
}
</script>

<style lang="sass">
.NavbarItemProfileLink
  img
    max-height: none
    height: 32px
    width: 32px
</style>
