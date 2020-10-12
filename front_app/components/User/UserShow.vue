<template lang="pug">
.UserShow(v-if="!$fetchState.pending")
  client-only
    b-navbar(type="is-primary" wrapper-class="container" :mobile-burger="false" spaced)
      template(slot="brand")
        HomeNavbarItem
        //- b-navbar-item(@click="back_handle")
        //-   .delete
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
          | {{config.name}}さんのプロフィール
      template(slot="end" v-if="g_current_user && g_current_user.id === config.id")
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'settings-profile'}" @click.native="sound_play('click')") 変更
    .section
      .container
        .columns.is-centered
          .column.is-7-desktop
            .has-text-centered
              b-image.is-inline-block(:src="config.avatar_path" rounded)
            .mt-4(v-if="config.twitter_key")
              .has-text-weight-bold Twitter
              a.is-block(:href="twitter_url" :target="target_default") @{{config.twitter_key}}
            .mt-4.box.description.has-background-white-ter.is-shadowless(v-if="config.description" v-html="auto_link(config.description)")
        pre(v-if="development_p") {{config}}
</template>

<script>
export default {
  name: "UserShow",
  data() {
    return {
      config: null,
    }
  },
  fetch() {
    // http://0.0.0.0:3000/api/users/1.json
    // http://0.0.0.0:4000/users/1
    return this.$axios.$get(`/api/users/${this.$route.params.id}.json`).then(e => {
      this.config = e
    })
  },
  methods: {
    back_handle() {
      this.sound_play('click')
      this.$router.go(-1)
    },
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
.UserShow
  .section
    padding-top: 2.8rem

  .image
    img
      width: 256px
      height: 256px
</style>
