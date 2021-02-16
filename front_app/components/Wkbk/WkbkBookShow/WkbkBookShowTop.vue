<<template lang="pug">
.WkbkBookShowTop
  MainSection
    .container.is-fluid
      //- .columns.is-gapless
      //-   .column
      //-     .box.is-shadowless.has-background-white-ter(v-if="base.book.description" v-html="simple_format(auto_link(base.book.description))")
      //-     .buttons
      //-       b-button(@click="base.play_start") スタート
      .columns
        .column.is-7
          .columns
            .column
              WkbkBookShowTopMainCard(:base="base")
          //- .columns.is-mobile.is-variable.is-1-mobile
          //- .columns.is-mobile.is-variable.is-1-mobile
          .columns
            .column
              WkbkBookShowTopTweetStat(:base="base")
            .column
              WkbkBookShowTopTweetRecent(:base="base")

        //- .column.is-one-third-tablet
        .column
          WkbkBookShowTopXitemList(:base="base" ref="WkbkBookShowTopXitemList")

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
      //-       b-button(@click="base.play_start" type="is-primary") START
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowTop",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookShowTop
    .column, .book_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkBookShowTop
  .MainSection.section
    +mobile
      padding: 1.0rem 0.75rem
    +tablet
      padding: 1.0rem 0.75rem

  // .columns
  //   flex-direction: row-reverse

  // +mobile
  //   padding: 0.5rem
  //
  // +tablet
  //   padding: 1rem
  //
  // +desktop
  //   padding: 1rem 0rem

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
