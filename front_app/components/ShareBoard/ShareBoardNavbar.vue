<template lang="pug">
MainNavbar.ShareBoardNavbar(:spaced="false" :type="base.edit_mode_p ? 'is-dark' : 'is-primary'")
  template(slot="brand")
    b-navbar-item(@click.native="base.exit_handle")
      b-icon(icon="home")

    b-navbar-item.has-text-weight-bold(@click="base.title_edit")
      | {{base.current_title}}
      span.mx-1(v-if="base.play_mode_p && turn_offset >= 1")
        | \#{{base.turn_offset}}

  template(slot="end")
    b-navbar-item.is-unselectable(tag="div" v-if="base.ac_room")
      b-icon(icon="account")
      b-tag.has-text-weight-bold(rounded)
        .has-text-primary {{base.member_infos.length}}

    b-navbar-item.has-text-weight-bold.px_5_if_tablet(@click="base.tweet_modal_handle" v-if="tweet_button_p")
      b-icon(icon="twitter" type="is-white")

    b-navbar-item.has-text-weight-bold(@click="base.play_mode_handle" v-if="base.edit_mode_p")
      | 編集完了

    // テストで参照しているので sidebar_toggle_navbar_item は取ったらいけん
    b-navbar-item.px_5_if_tablet.sidebar_toggle_navbar_item(@click="base.sidebar_toggle" v-if="base.play_mode_p")
      b-icon(icon="menu")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardNavbar
</style>
