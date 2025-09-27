<template lang="pug">
component(
  v-if="new_user"
  :is="component"
  class="NavbarItemProfileLink",
  :title="new_user.name"
  @click="click_handle"
  v-bind="$attrs"
  v-on="$listeners"
  )
  .image
    img.is-rounded(:src="new_user.avatar_path" :alt="new_user.name")
</template>

<script>
export default {
  name: "NavbarItemProfileLink",
  props: {
    user:      { type: Object,   default: null             },
    component: { type: String,   default: "b-navbar-item", },
    click_fn:  { type: Function, default: null,            },
  },
  methods: {
    click_handle(e) {
      if (this.click_fn) {
        this.click_fn(e)
      } else {
        this.sfx_click()
        this.$router.push("/lab/account")
      }
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
