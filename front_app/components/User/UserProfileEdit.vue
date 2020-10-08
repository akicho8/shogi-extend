<template lang="pug">
.UserProfileEdit(v-if="!$fetchState.pending")
  //- b-navbar(type="is-primary" wrapper-class="container" :mobile-burger="false" spaced)
  //-   template(slot="brand")
  //-     b-navbar-item(@click="back_handle")
  //-       .delete
  //-     b-navbar-item(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
  //-       //- .image.is-inline-block
  //-       //-   img.is-rounded(:src="config.avatar_path")
  //-       .ml-2.has-text-weight-bold {{config.name}}さんのプロフィール
  //-   template(slot="end" v-if="g_current_user && g_current_user.id === config.id")
  //-     b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'profile-edit'}") 変更
  //- .section
  //-   .container
  //-     client-only
  //-       b-image(:src="config.avatar_path")
  //-     .content
  //-       p
  //-         .has-text-weight-bold Twitter
  //-         a.is-block(:href="twitter_url" :target="target_default" ) @{{config.twitter_key}}
  //-       p.box.description.has-background-white-ter.is-shadowless(
  //-         v-if="config.description"
  //-         v-html="auto_link(config.description)")
  //-
  //-     pre(v-if="development_p") {{config}}
</template>

<script>
export default {
  name: "UserProfileEdit",
  data() {
    return {
      config: false,
    }
  },
  fetch() {
    // http://0.0.0.0:3000/api/users/1.json
    // http://0.0.0.0:4000/users/1
    // return this.$axios.$get(`/api/users/${this.$route.params.id}.json`).then(e => {
    //   this.config = e
    // })
  },
  methods: {
    // back_handle() {
    //   this.sound_play('click')
    //   this.$router.go(-1)
    // },
  },
  computed: {
    // twitter_url() {
    //   const v = this.config.twitter_key
    //   if (v) {
    //     return `https://twitter.com/${v}`
    //   }
    // },
  },
}
</script>

<style lang="sass">
.UserProfileEdit
  // .navbar-item
  //   img
  //     max-height: none
  //     height: 32px
  //     width: 32px
  .section
    padding-top: 1.5rem
</style>
