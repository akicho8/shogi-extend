<template lang="pug">
MainNavbar.KiwiBookEditNavbar(:spaced="false")
  template(v-if="base.book")
    template(slot="brand")
      b-navbar-item(tag="nuxt-link" :to="{name: 'video-books'}" @click.native="sound_play('click')")
        b-icon(icon="chevron-left")
    template(slot="start")
      template(v-if="base.book.title")
        b-navbar-item.px_0_if_mobile(tag="div") {{base.book.title}}
      template(v-else)
        //- b-navbar-item(tag="div") {{base.book.new_record_p ? '新規' : '編集'}}
    template(slot="end")
      //- https://buefy.org/documentation/navbar
      b-navbar-dropdown(arrowless right @click.native="sound_play('click')")
        //- https://pictogrammers.github.io/@mdi/font/5.4.55/
        b-icon.px_5_if_tablet(icon="dots-vertical" slot="label")
        b-navbar-item(@click.prevent.stop="base.download_handle(base.book)") ダウンロード
        b-navbar-item(@click.prevent.stop="base.book_delete_handle(base.book)") 削除

      b-navbar-item.px_5_if_tablet.has-text-weight-bold(@click="base.book_save_handle" :class="{disabled: !base.save_button_enabled}")
        | {{base.save_button_name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookEditNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.KiwiBookEditNavbar
</style>
