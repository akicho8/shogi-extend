<template lang="pug">
b-sidebar.WkbkBookShowSidebar.is-unselectable(fullheight right overlay v-model="sidebar_p" v-if="TheApp.book")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="TheApp.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action" v-if="TheApp.is_running_p")
          b-menu-item.is_active_unset(label="やめる" @click.native="TheApp.quit_handle" :disabled="!TheApp.is_running_p" v-if="false")
          b-menu-item.is_active_unset(:label="`現在の問題を別タブで編集`" @click="TheApp.article_edit_handle" :disabled="!TheApp.current_article_edit_p")
          b-menu-item.is_active_unset(:label="`現在の問題を別タブで開く`" @click="TheApp.article_show_handle" :disabled="!TheApp.current_article_show_p")
          b-menu-item.is_active_unset(:label="`1つ前の問題に戻る`" @click="TheApp.previous_handle")

        b-menu-list(label="管理" v-if="development_p && false")
          //- b-menu-item.is_active_unset(label="この問題集の編集"       @click.native="TheApp.book_edit_handle"    :disabled="!TheApp.owner_p")
          //- b-menu-item.is_active_unset(label="問題を追加する"         @click.native="TheApp.article_new_handle"  :disabled="!TheApp.owner_p")
          b-menu-item.is_active_unset(label="この問題集を編集"       @click="TheApp.book_edit_handle"    :disabled="!TheApp.owner_p")
          b-menu-item.is_active_unset(label="この問題集に問題を追加" @click="TheApp.article_new_handle"  :disabled="!TheApp.owner_p")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(label="ツイート"                 @click.native="TheApp.book_tweet_handle")
          b-menu-item.is_active_unset(label="ショートカット" @click.native="TheApp.kb_shortcut_modal_shortcut_handle")

      .box.mt-5
        .title.is-5 設定
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="TimeLimitFuncInfo"       :sync_value.sync="TheApp.time_limit_func_key"      )
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="TimeLimitSecInfo"        :sync_value.sync="TheApp.time_limit_sec"           )
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="AutoMoveInfo"            :sync_value.sync="TheApp.auto_move_key"         )
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="ArticleTitleDisplayInfo" :sync_value.sync="TheApp.article_title_display_key")
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="MovesMatchInfo"          :sync_value.sync="TheApp.moves_match_key"          )
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="CorrectBehaviorInfo"     :sync_value.sync="TheApp.correct_behavior_key"     )
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="ViewpointFlipInfo"       :sync_value.sync="TheApp.viewpoint_flip_key"       )
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="SoldierFlopInfo"         :sync_value.sync="TheApp.soldier_flop_key"         )
        SimpleRadioButton(:base="TheApp" custom-class="is-small" element_size="is-small" model_name="AppearanceThemeInfo"     :sync_value.sync="TheApp.appearance_theme_key"     )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowSidebar",
  mixins: [support_child],
  computed: {
    sidebar_p: {
      set(v) { this.TheApp.sidebar_set(v)   },
      get()  { return this.TheApp.sidebar_p },
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowSidebar
  .sidebar-content
    width: 20rem
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em

  // .field:not(:first-child)
  //   margin-top: 1.25rem
</style>
