<template lang="pug">
MainNavbar.WkbkBookShowNavbar(:spaced="false")
  template(slot="brand")
    b-navbar-item(tag="nuxt-link" :to="{name: 'wkbk-books'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
    b-navbar-item(tag="div") {{base.book.title}}
  template(slot="start")
    b-navbar-item.has-text-weight-bold(tag="div" v-if="base.current_article")
      span.mx-1.is-family-monospace {{base.current_index + 1}} / {{base.max_count}}

  template(slot="end")
    b-navbar-item.has-text-weight-bold.px-4(@click="base.next_handle" v-if="base.current_article")
      | NEXT
    b-navbar-item.has-text-weight-bold.px-4(@click="base.restart_handle" v-if="!base.current_article")
      | RESTART
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
