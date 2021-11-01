<template lang="pug">
b-sidebar.KiwiBananaShowSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      .box
        | とくに入れるもんなし
      b-menu
        //- b-menu-list(label="Action" v-if="base.is_running_p")
        b-menu-list(label="管理" v-if="development_p && false")
          //- b-menu-item.is_active_unset(label="この動画の編集"       @click.native="base.banana_edit_handle"    :disabled="!base.owner_p")
          //- b-menu-item.is_active_unset(label="問題を追加する"         @click.native="base.article_new_handle"  :disabled="!base.owner_p")
          //- b-menu-item.is_active_unset(label="この動画を編集"       @click="base.banana_edit_handle"    :disabled="!base.owner_p")
          //- b-menu-item.is_active_unset(label="この動画に問題を追加" @click="base.article_new_handle"  :disabled="!base.owner_p")

        //- b-menu-list(label="その他")
        //-   b-menu-item.is_active_unset(label="ツイート" @click.native="base.tweet_handle")
        //-   b-menu-item.is_active_unset(label="キーボードショートカット" @click.native="base.kb_shortcut_modal_toggle_handle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaShowSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaShowSidebar
  .sidebar-content
    width: unset
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
