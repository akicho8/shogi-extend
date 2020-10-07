<template lang="pug">
b-navbar-item.CurrentUserElement(
  tag="nuxt-link"
  :to="{name: 'users-id', params: {id: g_current_user.id}}"
  v-if="g_current_user"
  )
  .image
    img.is-rounded(:src="g_current_user.avatar_path")
</template>

<script>
import { mapState, mapMutations, mapActions } from "vuex"

export default {
  name: "CurrentUserElement",
  computed: {
    ...mapState('user', [
      'g_current_user'
    ])
  },
}
</script>

<style lang="sass">
.CurrentUserElement
  img
    max-height: none
    height: 32px
    width: 32px
</style>
