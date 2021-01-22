<template lang="pug">
MainNavbar.WkbkBookShowNavbar(:spaced="false")
  template(slot="brand")
    b-navbar-item(tag="nuxt-link" :to="{name: 'wkbk-books'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
  template(slot="start")
    template(v-if="base.book.title")
      b-navbar-item(tag="div") {{base.book.title}}
    template(v-else)
      b-navbar-item(tag="div") {{base.book.new_record_p ? '新規' : '編集'}}
  template(slot="end")
    b-navbar-item.has-text-weight-bold(@click="base.book_save_handle" :class="{disabled: !base.save_button_enabled}")
      | {{base.save_button_name}}
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
