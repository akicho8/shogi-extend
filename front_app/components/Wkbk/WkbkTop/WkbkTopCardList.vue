<template lang="pug">
.WkbkTopCardList.columns.is-multiline
  template(v-for="e in base.books")
    .column.is-one-quarter-widescreen.is-one-third-desktop.is-half-tablet
      //- https://bulma.io/documentation/components/card/
      nuxt-link.card.is-block(:to="{name: 'rack-books-book_key', params: {book_key: e.key}}" @click.native="sound_play('click')")
        //- .card.is-block
        .card-image
          figure.image
            img(:src="e.avatar_path" :alt="e.title")
            .position_top_right
              b-tag(rounded type="is-dark")
                | {{e.bookships_count}}
        .card-content
          .media
            .media-left
              figure.image.is-48x48
                img.is-rounded(:src="e.user.avatar_path" :alt="e.user.name")
            .media-content
              p.title.is-4 {{e.title}}
              p.subtitle.is-6
                | {{e.user.name}}
                br
                | {{updated_time_format(e.updated_at)}}
                b-icon.ml-2(:icon="FolderInfo.fetch(e.folder_key).icon" size="is-small" v-if="e.folder_key != 'public'")
                templete(v-if="e.tag_list.length >= 1")
                  br
                  span.tag_links
                    template(v-for="tag in e.tag_list")
                      span.has-text-link(@click.prevent.stop="base.tag_search_handle(tag)" :key="`${e.key}_${tag}`") \#{{tag}}

          //- template(v-for="tag in e.tag_list")
          //-   b-tag.is-clickable.mx-1(@click.native.stop="base.tag_search_handle(tag)" rounded :key="tag")
          //-     | {{tag}}

          .content(v-if="false")
            .description.is_truncate2(v-html="simple_format(auto_link(e.description))")

            //- .image.is-flex-shrink-0.user_avatar
            //-
            //- p(v-html="e.description")

          //- .image.user_image
          //-   img(:src="e.user.avatar_path")

          //- template(v-if="e.new_p")
          //-   span.has-text-danger.ml-2.is-size-6 NEW!
          //- p(v-html="e.description")
          //- ul.is-size-7.features
          //-   template(v-for="e in e.features")
          //-     li(v-html="e")
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "WkbkTopCardList",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkTopCardList
  .user_avatar
    img
      max-height: none
      height: 18px
      width:  18px
  .card-image
    figure.image

    // 個数
    .position_top_right
      position: absolute
      top: 0
      right: 0
      .tag
        margin: 6px
        background-color: change_color($black, $alpha: 0.5)

  .tag_links
    span:not(:first-child)
      margin-left: 0.25rem
</style>
