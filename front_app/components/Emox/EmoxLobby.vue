<template lang="pug">
.EmoxLobby
  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'emoshogi'}") エモ将棋
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink
  MainSection
    .container
      .columns
        .column
          .buttons.is-centered.mt-6.is-marginless.are-medium
            b-button.has-text-weight-bold(@click="base.start_handle" type="is-primary")
              | START

          .is-flex.is-size-7.is-justify-content-center.mt-6(v-if="staff_p || development_p")
            .mx-1(v-if="development_p")                購読{{base.ac_subscription_names}}
            .mx-1(v-if="base.school_user_ids != null") オンライン{{base.school_user_ids.length}}人
            .mx-1(v-if="base.matching_user_ids_hash")  対戦待ち{{base.matching_user_count}}人
            .mx-1(v-if="base.room_user_ids != null")   対戦中{{base.room_user_ids.length}}人

  EmoxMatchingOperation(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "EmoxLobby",
  mixins: [support_child],
  data() {
    return {
      debug_p: false,
    }
  },
}
</script>

<style lang="sass">
@import "support.sass"
.NODE_ENV-production
  .EmoxLobby
    .status_line
      color: $white
</style>
