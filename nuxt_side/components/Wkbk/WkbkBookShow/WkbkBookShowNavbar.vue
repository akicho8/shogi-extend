<template lang="pug">
MainNavbar.WkbkBookShowNavbar(v-bind="component_attrs")
  template(v-if="base.book")
    template(slot="brand")
      template(v-if="base.is_standby_p")
        b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-books'}" @click.native="sfx_play_click()")
          b-icon(icon="chevron-left")

      template(v-if="base.is_running_p")
        b-navbar-item.px_5_if_tablet(@click.native="base.quit_handle")
          b-icon(icon="chevron-left")

      template(v-if="base.is_goal_p")
        b-navbar-item.px_5_if_tablet(@click.native="base.close_handle")
          b-icon(icon="chevron-left")

      b-navbar-item(tag="a" @click.native="base.description_handle" v-if="development_p")
        b-icon(icon="information-outline")

      template(v-if="base.is_standby_p && false")
        b-navbar-item(tag="div")
          | {{base.book.title}}

    template(slot="start")
      template(v-if="base.is_running_p && false")
        b-navbar-item(tag="div" v-if="base.current_xitem")
          | {{base.current_xitem.title}}

      template(v-if="base.is_running_p")
        b-navbar-item(tag="div" v-if="base.current_xitem")
          span.mx-1.is-family-monospace.is-unselectable {{base.current_difficulty_rate_human}}
          span.mx-1.is-family-monospace.is-unselectable {{base.navbar_display_time}}
          span.mx-1.is-family-monospace.is-unselectable {{base.current_index + 1}}/{{base.max_count}}

        //- .slice().reverse()
        template(v-if="false")
          template(v-for="e in $gs.ary_reverse(base.AnswerKindInfo.values)")
            b-navbar-item.has-text-weight-bold.px-5.is-clickable.is-unselectable(@click="base.next_handle(e)" v-if="base.current_xitem")
              b-icon(:icon="e.icon")

    template(slot="end")
      template(v-if="base.is_standby_p")
        b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles-new', query: {book_key: base.book.key}}"        @click.native="sfx_play_click()" v-if="base.owner_p")
          b-icon(icon="plus")
        b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-books-book_key-edit', params: {book_key: base.book.key}}" @click.native="sfx_play_click()" v-if="base.owner_p")
          b-icon(icon="pencil")
        b-navbar-item.px_5_if_tablet.has-text-weight-bold(@click="base.book_tweet_handle" v-if="development_p")
          b-icon(icon="twitter" type="is-white")

      //- b-navbar-item.has-text-weight-bold.px-4(@click="base.play_start" v-if="!base.current_xitem")
      //-   | RESTART

      NavbarItemSidebarOpen(@click="base.sidebar_toggle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowNavbar",
  mixins: [support_child],
  computed: {
    component_attrs() {
      const hv = {}

      hv.centered = true
      hv["wrapper-class"] = "container is-fluid px-0"

      // hv.transparent = true
      hv.type = this.TheApp.appearance_theme_info.navbar_type

      hv.spaced = false

      // if (this.TheApp.edit_mode_p) {
      //   hv.type = "is-dark"
      // } else {
      //   if (this.TheApp.order_enable_p) {
      //     // hv.transparent = true
      //     // hv.type = ""
      //   } else {
      //   }
      //   // hv.type = "is-primary"
      //   // hv.type = "is-primary"
      //   if (this.TheApp.AppConfig.NAVBAR_COLOR_CHANGE) {
      //     if (this.TheApp.clock_box) {
      //       if (this.TheApp.clock_box.play_p) {
      //         const rest = this.TheApp.clock_box.current.rest
      //         if (rest <= 10) {
      //           hv.type = "is-danger"
      //         } else if (rest <= 20) {
      //           hv.type = "is-warning"
      //         }
      //       }
      //     }
      //   }
      // }

      return hv
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowNavbar
  __css_keep__: 0
</style>
