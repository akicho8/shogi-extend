<template lang="pug">
.KiwiTopContent.columns.is-multiline.is-variable.is-0-mobile.is-1-tablet.is-2-desktop.is-3-widescreen
  .column.is-12
    .buttons
      template(v-for="e in base.SearchPresetInfo.values")
        b-button(@click="base.search_preset_handle(e)") {{e.name}}

  KiwiTopTagList(:base="base")

  .column.is-4-tablet.is-3-desktop.is-2-widescreen(v-for="e in base.books")
    nuxt-link.card.is-clickable(tag="div" :to="{name: 'video-watch-book_key', params: {book_key: e.key}}" @click.native="sound_play('click')")
      .card-image
        figure.image
          img(:src="e.lemon.thumbnail_browser_path")
      .card-content
        KiwiBookInfo(:base="base" :book="e" :key="e.key" type="is_compact")
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "KiwiTopContent",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"

.KiwiTopContent
  .card-content
    padding: 1rem

//- +mobile
//-   .KiwiTopContent.columns
//-     margin-bottom: 0
//-     .column
//-       padding: 0
//-       &:not(:first-child)
//-         margin-top: 0.75rem

// .KiwiTopContent
//   .user_avatar
//     img
//       max-height: none
//       height: 18px
//       width:  18px
//
//   .hashtags
//     span:not(:first-child)
//       margin-left: 0.25rem
//
//   .media-content
//     // p
//     //   line-height: 1.25rem
</style>
