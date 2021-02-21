<template lang="pug">
b-sidebar.WkbkBookShowSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p" v-if="base.book")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action" v-if="base.is_running_p")
          b-menu-item(label="やめる"                                          @click.native="base.quit_handle"       :disabled="!base.is_running_p")
          b-menu-item(:label="`現在の問題を別タブで開く`" @click.native="base.article_show_handle" :disabled="!base.article_show_p")

        b-menu-list(label="管理" v-if="development_p && false")
          //- b-menu-item(label="この問題集の編集"       @click.native="base.book_edit_handle"    :disabled="!base.owner_p")
          //- b-menu-item(label="問題を追加する"         @click.native="base.article_new_handle"  :disabled="!base.owner_p")
          b-menu-item(label="この問題集を編集"       @click.native="base.book_edit_handle"    :disabled="!base.owner_p")
          b-menu-item(label="この問題集に問題を追加" @click.native="base.article_new_handle"  :disabled="!base.owner_p")

        b-menu-list(label="その他")
          b-menu-item(label="ツイート"               @click.native="base.book_tweet_handle")

        b-menu-list(label="表示オプション" v-if="base.visible_hash")
          b-menu-item.sidebar_columns_toggle(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 表示カラム
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.BookShowColumnInfo.values")
              b-menu-item(
                v-if="e.togglable"
                @click.stop="base.cb_toggle_handle(e)"
                :class="{is_visible_off: !base.visible_hash[e.key], is_visible_on: base.visible_hash[e.key]}"
                :key="e.key"
                :label="e.name"
                )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowSidebar
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em

</style>
