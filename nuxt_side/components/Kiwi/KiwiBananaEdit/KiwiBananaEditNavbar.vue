<template lang="pug">
MainNavbar.KiwiBananaEditNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
  template(v-if="base.banana")
    template(slot="brand")
      b-navbar-item(tag="nuxt-link" :to="{name: 'video-studio'}" @click.native="sfx_play_click()")
        b-icon(icon="chevron-left")
    template(slot="start")
      b-navbar-item.px_0_if_mobile.has-text-weight-bold(tag="div")
        template(v-if="base.banana.new_record_p")
          | 動画ライブラリ (登録)
        template(v-else)
          | 動画情報 (編集)

      //- template(v-if="base.banana.title")
      //-   b-navbar-item.px_0_if_mobile(tag="div") {{base.banana.title}}
      //- template(v-else)
      //-   //- b-navbar-item(tag="div") {{base.banana.new_record_p ? '新規' : '編集'}}
    template(slot="end")
      //- https://buefy.org/documentation/navbar
      b-navbar-dropdown(arrowless right @click.native="sfx_play_click()")
        //- https://pictogrammers.github.io/@mdi/font/5.4.55/
        b-icon.px_5_if_tablet(icon="dots-vertical" slot="label")
        //- b-navbar-item(@click.prevent.stop="base.download_handle(base.banana)") ダウンロード
        b-navbar-item(@click.prevent.stop="base.delete_handle(base.banana)") 削除

      //- b-navbar-item.px_5_if_tablet.has-text-weight-bold(@click="base.banana_save_handle" :class="{disabled: !base.save_button_enabled}")
      //-   | {{base.save_button_name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaEditNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaEditNavbar
  __css_keep__: 0
</style>
