<template lang="pug">
.SwarsBattleIndexMembership(:class="{'has_badge': has_badge}")
  .icon_with_name
    template(v-if="has_badge && membership.badge_params")
      MembershipBadge(:params="membership.badge_params" )
    SwarsBattleShowUserLink(:membership="membership" :with_user_key="with_user_key" :query="APP.query_for_link")
    //- template(v-if="row.xmode_info.key === '友達'")
    //-   XemojiWrap.is-flex-shrink-0.ml-2(str="👬")
  .tactic_tags(v-if="available_tag_list_names.length >= 1")
    template(v-for="key in available_tag_list_names")
      template(v-for="name in membership[key]")
        nuxt-link.tactic_tag(:to="{name: 'swars-search', query: {query: new_query(name)}}" @click.native="$sound.play_click()") {{name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexMembership",
  mixins: [support_child],
  props: {
    row:           { type: Object,  required: true },
    membership:    { type: Object,  required: true },
    with_user_key: { type: Boolean, required: true },
  },
  methods: {
    new_query(name) {
      if (false) {
        return [this.membership.user.key, `tag:${name}`].join(" ")
      } else {
        return name
      }
    },
  },
  computed: {
    // バッジを表示するか？
    has_badge() { return this.APP.column_visible_p("badge") },

    // 表示するタグ変数名たち
    available_tag_list_names() { return this.APP.TacticInfo.values.map(e => e.tag_list_name).filter(e => this.APP.column_visible_p(e)) },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexMembership
  .icon_with_name
    display: flex
    align-items: center
    justify-content: flex-start
    font-size: $size-5

  // Bulma の .tags tag があまりにも複雑で何やっても謎のスペースがあくので自分で書く
  // (おそらく inline-flex が原因だとは思う)
  .tactic_tags
    display: flex
    flex-wrap: wrap
    gap: 2px                    // 全体の隙間
    .tactic_tag
      // とにかく真ん中
      display: flex
      align-items: center
      justify-content: center
      // 折り返さない
      white-space: nowrap
      // サイズ
      font-size: $size-small
      height: 2em
      line-height: 1.0
      // 装飾
      background-color: $background
      border-radius: $radius-rounded
      color: $text
      // なかの余白
      padding-left: 0.75em
      padding-right: 0.75em

  // バッジがあってタブレット以上なら戦法の左をアイコンのぶんだけずらしておく
  &.has_badge
    .tactic_tags
      +tablet
        margin-left: 1.5rem

  .SwarsBattleShowUserLink
    // &.is-win
    // &.is-lose
    //   color: $text
    //   &:hover
    //     color: $link

// モバイル時(縦表示)のとき
.has-mobile-cards
  +mobile
    .SwarsBattleIndexMembership
      .icon_with_name
        // 名前を大きくする
        font-size: $size-4
        // 名前を右寄せ
        justify-content: flex-end

    .tactic_tags
      // タグを右寄せ
      justify-content: flex-end

.STAGE-development-x
  .SwarsBattleIndexMembership
    .icon_with_name
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .tactic_tags
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
