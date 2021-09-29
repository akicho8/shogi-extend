<template lang="pug">
MainNavbar.KiwiBookShowNavbar(:spaced="false" centered wrapper-class="container is-fluid px-0")
  template(slot="brand")
    b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")

      //- template(v-if="base.is_running_p")
      //-   b-navbar-item.px_5_if_tablet(@click.native="base.quit_handle")
      //-     b-icon(icon="chevron-left")
      //- 
      //- template(v-if="base.is_goal_p")
      //-   b-navbar-item.px_5_if_tablet(@click.native="base.close_handle")
      //-     b-icon(icon="chevron-left")

      //- b-navbar-item(tag="a" @click.native="base.description_handle" v-if="development_p")
      //-   b-icon(icon="information-outline")

      //- template(v-if="base.is_standby_p && false")
      //-   b-navbar-item(tag="div")
      //-     | {{base.book.title}}

  //- template(slot="start")

  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink
    KiwiSidebarToggle(@click="base.sidebar_toggle"  v-if="false")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookShowNavbar
</style>
