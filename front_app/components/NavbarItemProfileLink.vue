<template lang="pug">
component(
  v-if="new_user"
  :is="component"
  class="NavbarItemProfileLink",
  :title="new_user.name"
  @click="click_handle"
  )
  .image
    img.is-rounded(:src="new_user.avatar_path" :alt="new_user.name")
</template>

<script>
export default {
  name: "NavbarItemProfileLink",
  props: {
    user: { type: Object, default: null },
    component: { type: String, default: "b-navbar-item", },
  },
  methods: {
    click_handle() {
      this.sound_play("click")
      this.$router.push({name: 'users-id', params: {id: this.new_user.id}})
    },
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
