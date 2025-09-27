<template lang="pug">
.SwarsBattleIndexMembership(:class="{'has_badge': has_badge}")
  .icon_with_name
    template(v-if="has_badge && membership.badge_params")
      MembershipBadge(:params="membership.badge_params" )
    SwarsBattleShowUserLink(:membership="membership" :with_user_key="with_user_key" :query="APP.query_for_link")
    //- template(v-if="row.xmode_info.key === '友達'")
    //-   XemojiWrap.is-flex-shrink-0.ml-2(str="👬")
  b-taglist.mb-1(v-if="available_tag_list_names.length >= 1")
    template(v-for="key in available_tag_list_names")
      template(v-for="name in membership[key]")
        nuxt-link.tag.is-rounded.is-marginless(:to="{name: 'swars-search', query: {query: new_query(name)}}" @click.native="sfx_play_click()")
          | {{name}}
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

  .tags
    gap: 3px

  // バッジがあってタブレット以上なら戦法の左をアイコンのぶんだけずらしておく
  &.has_badge
    .tags
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

    .tags
      // タグを右寄せ
      justify-content: flex-end

.STAGE-development-x
  .SwarsBattleIndexMembership
    .icon_with_name
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .tags
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
