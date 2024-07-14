<template lang="pug">
DotsMenuButton.SwarsUserShowDropdownMenu
  template(v-if="development_p")
    b-dropdown-item(@click="TheApp.update_handle({badge_debug: true})")
      span バッジ全表示 ON
    b-dropdown-item(@click="TheApp.update_handle({badge_debug: false})")
      span バッジ全表示 OFF
    b-dropdown-item(separator)

  // この下のアイテムはすべてクリック音を設定してない
  // なんか変な気もするけど押したときに伝搬して b-dropdown で鳴る
  //- b-dropdown-item(@click="TheApp.search_by_user_key_handle" v-if="development_p")
  //-   b-icon(icon="magnify" size="is-small")
  //-   span 棋譜検索

  b-dropdown-item(@click="TheApp.filter_modal_handle")
    b-icon(icon="filter-outline" size="is-small")
    span 絞り込み

  b-dropdown-item(separator)

  //- b-dropdown-item(@click="TheApp.update_handle({try_fetch: true})" v-if="development_p")
  //-   b-icon(icon="sync" size="is-small")
  //-   span 更新

  template(v-for="e in TheApp.SampleMaxInfo.values")
    template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
      b-dropdown-item(@click="TheApp.update_handle({sample_max: e.value})" :class="{'is-active': TheApp.sample_max === e.value}")
        b-icon(icon="arrow-up-bold" size="is-small")
        span {{e.name}}

  b-dropdown-item(separator)

  b-dropdown-item(:href="TheApp.twitter_search_url" :target="target_default")
    b-icon(icon="twitter" size="is-small" type="is-twitter")
    span Twitter 検索

  b-dropdown-item(:href="TheApp.google_search_url" :target="target_default")
    b-icon(icon="google" size="is-small")
    span ぐぐる

  b-dropdown-item(:href="TheApp.swars_player_url" :target="target_default")
    b-icon(icon="link" size="is-small")
    span 本家

  b-dropdown-item(:href="TheApp.swars_player_follow_url" :target="target_default" v-if="development_p || true")
    b-icon(icon="account-arrow-right" size="is-small")
    span 友達登録している

  b-dropdown-item(:href="TheApp.swars_player_follower_url" :target="target_default" v-if="development_p || true")
    b-icon(icon="account-arrow-left" size="is-small")
    span 友達登録されている

  b-dropdown-item.is-hidden-desktop(separator)
  b-dropdown-item.is-hidden-desktop(has-link)
    a キャンセル
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowDropdownMenu",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowDropdownMenu
  .dropdown-menu
    span:not(.icon)
      margin-left: 0.5rem
</style>
