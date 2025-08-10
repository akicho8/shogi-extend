<template lang="pug">
.SwarsBattleIndexMembership(:class="{'has_badge': has_badge}")
  .icon_with_name
    template(v-if="has_badge && membership.badge_params")
      MembershipBadge(:params="membership.badge_params" )
    SwarsBattleShowUserLink(:membership="membership" :with_user_key="with_user_key" :query="APP.query_for_link")
    //- template(v-if="row.xmode_info.key === '友達'")
    //-   XemojiWrap.is-flex-shrink-0.ml-2(str="👬")
  b-taglist(v-if="APP.column_visible_p('attack_tag_list') || APP.column_visible_p('defense_tag_list')")
    template(v-for="key in ['attack_tag_list', 'defense_tag_list', 'technique_tag_list', 'note_tag_list']")
      template(v-if="APP.column_visible_p(key)")
        template(v-for="name in membership[key]")
          nuxt-link(:to="{name: 'swars-search', query: {query: new_query(name)}}" @click.native="$sound.play_click()")
            b-tag(rounded) {{name}}
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
    has_badge() { return this.APP.column_visible_p('badge') },
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
    margin-bottom: 0
    .tag
      margin-bottom: 0
    a
      margin: 0           // 右方向にあるマージを除去
      &:not(:first-child)
        margin-left: 2px  // タグ同士の隙間

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

// 縦表示のとき
.has-mobile-cards
  +mobile
    .SwarsBattleIndexMembership
      // モバイルのときは縦表示になるので名前を大きくする
      .icon_with_name
        font-size: $size-4
        justify-content: flex-end

    // モバイル時は折り返しありの右より
    .tags
      flex-wrap: wrap
      justify-content: flex-end
      align-items: center
      align-content: flex-start

.STAGE-development
  .SwarsBattleIndexMembership
    .icon_with_name
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .tags
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
