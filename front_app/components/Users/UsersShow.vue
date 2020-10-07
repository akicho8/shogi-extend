<template lang="pug">
.UsersShow(v-if="!$fetchState.pending")
  b-navbar(type="is-primary" wrapper-class="container" :mobile-burger="false" spaced)
    template(slot="brand")
      HomeNavbarItem
      b-navbar-item(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
        .image.is-inline-block
          img.is-rounded(:src="config.avatar_path")
        .ml-2.has-text-weight-bold {{config.name}}
      b-navbar-item(tag="a" :href="twitter_url" :target="target_default" v-if="twitter_url")
        | @{{config.twitter_key}}
  .section
    .container
      .box.description.has-background-white-ter.is-shadowless.is-size-7.mt-4(
        v-if="config.description"
        v-html="auto_link(config.description)")
      pre(v-if="development_p") {{config}}
</template>

<script>
export default {
  name: "UsersShow",
  data() {
    return {
      config: false,
    }
  },
  fetch() {
    // http://0.0.0.0:3000/api/users/1.json
    // http://0.0.0.0:4000/users/1
    return this.$axios.$get(`/api/users/${this.$route.params.id}.json`).then(e => {
      this.config = e
    })
  },
  computed: {
    twitter_url() {
      const v = this.config.twitter_key
      if (v) {
        return `https://twitter.com/${v}`
      }
    },
  },
}
</script>

<style lang="sass">
.UsersShow
 .navbar-item
   img
     max-height: none
     height: 32px
     width: 32px
</style>
