<template lang="pug">
.EmoxLobby
  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'emoshogi'}") エモ将棋
    template(slot="end")
      NavbarItemLogin
  MainSection
    .container
      .columns
        .column
          ul.is-flex.has-text-grey.is-size-7-mobile.is-justify-content-center
            li.mx-1(v-if="development_p")                購読{{base.ac_subscription_names}}
            li.mx-1(v-if="base.school_user_ids != null") オンライン{{base.school_user_ids.length}}人
            li.mx-1(v-if="base.matching_user_ids_hash")  対戦待ち{{base.matching_user_count}}人
            li.mx-1(v-if="base.room_user_ids != null")   対戦中{{base.room_user_ids.length}}人

          .buttons.is-centered.mt-6.is-marginless.are-large
            b-button.has-text-weight-bold(@click="base.start_handle" type="is-primary")
              | START

  EmoxMatchingOperation(:base="base")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "EmoxLobby",
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.EmoxLobby
</style>
