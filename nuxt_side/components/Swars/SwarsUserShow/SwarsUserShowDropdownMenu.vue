<template lang="pug">
DotsMenuButton.SwarsUserShowDropdownMenu
  // この下のアイテムはすべてクリック音を設定してない
  // なんか変な気もするけど押したときに伝搬して b-dropdown で鳴る
  b-dropdown-item(@click="base.search_by_user_key_handle")
    b-icon(icon="magnify" size="is-small")
    span 棋譜検索

  b-dropdown-item(separator)

  b-dropdown-item(@click="base.update_handle({try_fetch: true})" v-if="development_p")
    b-icon(icon="sync" size="is-small")
    span 更新

  b-dropdown-item(@click="base.update_handle({sample_max: 0})" v-if="development_p")
    b-icon(icon="arrow-up-bold" size="is-small")
    span 最大0件

  b-dropdown-item(@click="base.update_handle({sample_max: 1})" v-if="development_p")
    b-icon(icon="arrow-up-bold" size="is-small")
    span 最大1件

  template(v-for="e in base.SampleMaxInfo.values")
    b-dropdown-item(@click="base.update_handle({sample_max: e.value})" :class="{'is-active': base.sample_max === e.value}")
      b-icon(icon="arrow-up-bold" size="is-small")
      span {{e.name}}

  b-dropdown-item(separator)

  template(v-for="e in base.RuleSelectInfo.values")
    b-dropdown-item(@click="base.update_handle({rule: e.key})" :class="{'is-active': base.rule === e.key}")
      b-icon(icon="clock-outline" size="is-small")
      span {{e.name}}

  b-dropdown-item(separator)

  template(v-for="e in base.XmodeSelectInfo.values")
    b-dropdown-item(@click="base.update_handle({xmode: e.key})" :class="{'is-active': base.xmode === e.key}")
      b-icon(icon="account" size="is-small")
      span {{e.name}}

  b-dropdown-item(separator)

  b-dropdown-item(:href="base.twitter_search_url" :target="target_default")
    b-icon(icon="twitter" size="is-small" type="is-twitter")
    span Twitter検索

  b-dropdown-item(:href="base.google_search_url" :target="target_default")
    b-icon(icon="google" size="is-small")
    span ぐぐる

  b-dropdown-item(:href="base.swars_player_url" :target="target_default")
    b-icon(icon="link" size="is-small")
    span ウォーズ本家

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
