<template lang="pug">
MainNavbar.WkbkBookShowNavbar(:spaced="false")
  template(v-if="base.book")
    template(slot="brand")
      WkbkSidebarToggle(@click="base.sidebar_toggle")

      template(v-if="base.is_standby_p")
        b-navbar-item(tag="nuxt-link" :to="{name: 'rack-books'}" @click.native="sound_play('click')")
          b-icon(icon="chevron-left")

      template(v-if="base.is_running_p")
        b-navbar-item(@click.native="base.retire_handle")
          b-icon(icon="chevron-left")

      template(v-if="base.is_goal_p")
        b-navbar-item(@click.native="base.close_handle")
          b-icon(icon="chevron-left")

        //- b-navbar-item(tag="a" @click.native="base.description_handle")
        //-   b-icon(icon="information-outline")

        //- b-navbar-item(tag="a" @click.native="base.description_handle")
        //-   b-icon(icon="information-outline")

      template(v-if="base.is_standby_p && false")
        b-navbar-item(tag="div")
          | {{base.book.title}}

    template(slot="start")
      //- WkbkSidebarToggle(@click="base.sidebar_toggle")
      template(v-if="base.is_running_p && false")
        b-navbar-item(tag="div" v-if="base.current_article")
          | {{base.current_article.title}}

    template(slot="end")
      template(v-if="base.is_running_p")
        b-navbar-item(tag="div" v-if="base.current_article")
          span.mx-1.is-family-monospace {{base.current_index + 1}}/{{base.max_count}}
        b-navbar-item.has-text-weight-bold.px-5.is-clickable(@click="base.next_handle(false)" v-if="base.current_article") ×
        b-navbar-item.has-text-weight-bold.px-5.is-clickable(@click="base.next_handle(true)"  v-if="base.current_article") ○
      template(v-if="base.is_standby_p && development_p")
        b-navbar-item.has-text-weight-bold(@click="base.book_tweet_handle")
          b-icon(icon="twitter" type="is-white")

      //- b-navbar-item.has-text-weight-bold.px-4(@click="base.play_restart" v-if="!base.current_article")
      //-   | RESTART
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowNavbar
</style>
