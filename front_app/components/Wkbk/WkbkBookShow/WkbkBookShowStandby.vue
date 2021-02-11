<<template lang="pug">
.WkbkBookShowStandby
  //- .columns.is-gapless
  //-   .column
  //-     .box.is-shadowless.has-background-white-ter(v-if="base.book.description" v-html="simple_format(auto_link(base.book.description))")
  //-     .buttons
  //-       b-button(@click="base.play_restart") スタート

  .columns.is-gapless
    .column.main_column
      //- .is-flex.is-justify-content-center
      .card.is-block
        .card-image
          figure.image
            img(:src="base.book.avatar_path" :alt="base.book.title")
        .card-content
          .media
            .media-left
              nuxt-link.image.is-48x48.is-clickable(:to="{name: 'users-id', params: {id: base.book.user.id}}" @click.native="sound_play('click')")
                img.is-rounded(:src="base.book.user.avatar_path" :alt="base.book.user.name")
            .media-content
               p.title.is-4 {{base.book.title}}
               p.subtitle.is-6
                 nuxt-link(:to="{name: 'users-id', params: {id: base.book.user.id}}" @click.native="sound_play('click')")
                   | {{base.book.user.name}}
                 br
                 | {{diff_time_format(base.book.updated_at)}}更新
                 b-icon.ml-2(:icon="FolderInfo.fetch(base.book.folder_key).icon" size="is-small" v-if="base.book.folder_key != 'public'")
          .content
            .description(v-html="simple_format(auto_link(base.book.description))")
        .card-footer
          a.card-footer-item.has-text-weight-bold(@click="base.play_restart") はじめる
          nuxt-link.card-footer-item(:to="{name: 'rack-articles-new', query: {book_key: base.book.key}}"        @click.native="sound_play('click')" v-if="base.owner_p") 問題追加
          nuxt-link.card-footer-item(:to="{name: 'rack-books-book_key-edit', params: {book_key: base.book.key}}" @click.native="sound_play('click')" v-if="base.owner_p") 編集
    .column.is-one-third-tablet.sub_column
      WkbkBookShowArticleIndexTable(:base="base")

      //- (:to="{name: 'rack-books-book_key', params: {book_key: base.book.key}}" @click.native="sound_play('click')")
      //- nuxt-link.card-footer-item(:to="{name: 'swars-battles', query: {query: 'ok'}}") リンク
      //- b-button(tag="nuxt-link" :to="{name: 'settings-battles', query: {query: 'ok'}}") リンク
      //- b-menu-item(tag="nuxt-link" :to="{name: 'swars-users-key', params: {key: config.current_swars_user_key}}" @click.native="sound_play('click')" icon="account" label="プレイヤー情報" :disabled="!config.current_swars_user_key")

  //- .is-flex.is-justify-content-center
  //-   .hero.is-medium
  //-     .hero-body
  //-       //- p.title.has-text-centered
  //-       //-   | {{base.book.title}}
  //-       //- p.mt-5.subtitle.box.has-background-white-ter.is-shadowless.has-text-left(v-html="simple_format(auto_link(base.book.description))" v-if="base.book.description")
  //-
  //-       figure.image
  //-         img(:src="base.book.avatar_path" :alt="base.book.title")
  //-
  //-       .media
  //-         .media-left
  //-           figure.image.is-48x48
  //-             img.is-rounded(:src="base.book.user.avatar_path" :alt="base.book.user.name")
  //-         .media-content
  //-            p.title.is-4 {{base.book.title}}
  //-            p.subtitle.is-6
  //-              | {{base.book.user.name}}
  //-              br
  //-              | {{diff_time_format(base.book.updated_at)}}更新
  //-              b-icon.ml-2(:icon="FolderInfo.fetch(base.book.folder_key).icon" size="is-small" v-if="base.book.folder_key != 'public'")
  //-       .content
  //-         .description(v-html="simple_format(auto_link(base.book.description))")

  //- .columns.is-gapless
  //-   .column
  //-     .buttons
  //-       b-button(@click="base.play_restart" type="is-primary") はじめる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowStandby",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookShowStandby
    .column, .book_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkBookShowStandby
  .columns
    flex-direction: row-reverse

  +mobile
    padding: 0.5rem

  +tablet
    padding: 1rem

  +desktop
    padding: 1rem 0rem

  // .card
  //   +desktop
  //     max-width: 80ch

  // margin: $wkbk_share_gap
  // .column
  //   display: flex
  //   justify-content: center
  //   align-items: center
  //   flex-direction: column

  // .hero
  //   +tablet
  //     width: 50ch

  // .box
  //   width: 100%
  //   +tablet
  //     width: 65ch
</style>
