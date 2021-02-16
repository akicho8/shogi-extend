<<template lang="pug">
.WkbkBookShowTopMainCard
  .card.is-block
    .card-image
      figure.image
        img(:src="base.book.avatar_path" :alt="base.book.title")
        .position_top_right
          b-tag(rounded type="is-dark")
            | {{base.book.bookships_count}}
    .card-content
      .media
        .media-left
          nuxt-link.image.is-48x48.is-clickable(:to="{name: 'users-id', params: {id: base.book.user.id}}" @click.native="sound_play('click')")
            img.is-rounded(:src="base.book.user.avatar_path" :alt="base.book.user.name")
        .media-content
          //- p(v-if="base.book.tag_list.length >= 1")
          //-   span.tag_links
          //-     template(v-for="tag in base.book.tag_list")
          //-       a.has-text-link(@click.prevent.stop="base.tag_search_handle(tag)" :key="`${base.book.key}_${tag}`") \#{{tag}}
          p.title.is-4 {{base.book.title}}
          p.subtitle.is-6
            nuxt-link(:to="{name: 'users-id', params: {id: base.book.user.id}}" @click.native="sound_play('click')")
              | {{base.book.user.name}}
            span.mx-1 {{diff_time_format(base.book.updated_at)}}更新
            b-icon.mx-1(:icon="FolderInfo.fetch(base.book.folder_key).icon" size="is-small" v-if="base.book.folder_key != 'public'")
            templete(v-if="base.book.tag_list.length >= 1")
              br
              span.tag_links
                template(v-for="tag in base.book.tag_list")
                  a.has-text-link(@click.prevent.stop="base.tag_search_handle(tag)" :key="`${base.book.key}_${tag}`") \#{{tag}}
          .content
            .description(v-html="simple_format(auto_link(base.book.description))")
    .card-footer
      a.card-footer-item.has-text-weight-bold(@click="base.play_start") START
      nuxt-link.card-footer-item(:to="{name: 'rack-articles-new', query: {book_key: base.book.key}}"        @click.native="sound_play('click')" v-if="base.owner_p") 問題追加
      nuxt-link.card-footer-item(:to="{name: 'rack-books-book_key-edit', params: {book_key: base.book.key}}" @click.native="sound_play('click')" v-if="base.owner_p") 編集
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowTopMainCard",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookShowTopMainCard

.WkbkBookShowTopMainCard
  .card-image
    // 個数
    .position_top_right
      position: absolute
      top: 0
      right: 0
      .tag
        margin: 6px
        background-color: change_color($black, $alpha: 0.5)

  .tag_links
    a:not(:first-child)
      margin-left: 0.25rem
</style>
