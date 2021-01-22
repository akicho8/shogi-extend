<template lang="pug">
MainNavbar.WkbkArticleEditNavbar(:spaced="false")
  template(slot="brand")
    b-navbar-item(tag="nuxt-link" :to="{name: 'wkbk-articles'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
  template(slot="start")
    template(v-if="base.article.title")
      b-navbar-item(tag="div") {{base.article.title}}
    template(v-else)
      b-navbar-item(tag="div") {{base.article.new_record_p ? '新規' : '編集'}}
  template(slot="end")
    b-navbar-item.has-text-weight-bold(@click="base.article_save_handle" :class="{disabled: !base.save_button_enabled}")
      | {{base.save_button_name}}
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
</style>
