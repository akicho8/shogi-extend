<template lang="pug">
b-sidebar.WkbkBookShowSidebar.is-unselectable(fullheight right overlay v-model="sidebar_p" v-if="base.book")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action" v-if="base.is_running_p")
          b-menu-item.is_active_unset(label="やめる" @click.native="base.quit_handle" :disabled="!base.is_running_p" v-if="false")
          b-menu-item.is_active_unset(:label="`現在の問題を別タブで編集`" @click="base.article_edit_handle" :disabled="!base.current_article_edit_p")
          b-menu-item.is_active_unset(:label="`現在の問題を別タブで開く`" @click="base.article_show_handle" :disabled="!base.current_article_show_p")
          b-menu-item.is_active_unset(:label="`1つ前の問題に戻る`" @click="base.previous_handle")

        b-menu-list(label="管理" v-if="development_p && false")
          //- b-menu-item.is_active_unset(label="この問題集の編集"       @click.native="base.book_edit_handle"    :disabled="!base.owner_p")
          //- b-menu-item.is_active_unset(label="問題を追加する"         @click.native="base.article_new_handle"  :disabled="!base.owner_p")
          b-menu-item.is_active_unset(label="この問題集を編集"       @click="base.book_edit_handle"    :disabled="!base.owner_p")
          b-menu-item.is_active_unset(label="この問題集に問題を追加" @click="base.article_new_handle"  :disabled="!base.owner_p")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(label="ツイート" @click.native="base.book_tweet_handle")
          b-menu-item.is_active_unset(label="キーボードショートカット" @click.native="base.kb_shortcut_modal_toggle_handle")

      .box.mt-5
        .title.is-5 設定
        b-field(custom-class="is-small" label="問題タイトル表示")
          template(v-for="e in base.ArticleTitleDisplayInfo.values")
            b-radio-button(size="is-small" v-model="base.article_title_display_key" :native-value="e.key" @input="sound_play('click')") {{e.name}}
        b-field(custom-class="is-small" label="正解と一致したときの挙動")
          template(v-for="e in base.CorrectBehaviorInfo.values")
            b-radio-button(size="is-small" v-model="base.correct_behavior_key" :native-value="e.key" @input="sound_play('click')") {{e.name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowSidebar",
  mixins: [support_child],
  computed: {
    sidebar_p: {
      set(v) { this.base.sidebar_set(v)   },
      get()  { return this.base.sidebar_p },
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowSidebar
  .sidebar-content
    width: unset
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
