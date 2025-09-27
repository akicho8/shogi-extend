<template lang="pug">
MainNavbar.WkbkArticleEditNavbar(:spaced="false")
  template(v-if="base.article")
    template(slot="brand")
      b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles'}" @click.native="sfx_play_click()")
        b-icon(icon="chevron-left")
    template(slot="start")
      template(v-if="base.article.title")
        b-navbar-item.px_0_if_mobile(tag="div") {{base.article.title || "(no title)"}}
      template(v-else)
        //- b-navbar-item(tag="div") {{base.article.new_record_p ? '新規' : '編集'}}
    template(slot="end")
      b-navbar-item.px_5_if_tablet.has-text-weight-bold(@click="base.article_save_handle" :class="{disabled: !base.save_button_enabled}")
        | {{base.save_button_name}}

      //- https://buefy.org/documentation/navbar
      b-navbar-dropdown(arrowless right @click.native="sfx_play_click()")
        //- https://pictogrammers.github.io/@mdi/font/5.4.55/
        b-icon.px_5_if_tablet(icon="dots-vertical" slot="label")
        b-navbar-item(@click.prevent.stop="base.article_delete_handle(base.article)") 削除
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleEditNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleEditNavbar
  __css_keep__: 0
</style>
