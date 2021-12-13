<template lang="pug">
.SwarsBattleIndexMembership(:class="{'has_medal': has_medal}")
  .icon_with_name
    MembershipMedal(:params="membership.medal_params" v-if="has_medal && membership.medal_params")
    SwarsBattleShowUserLink(:membership="membership" :with_user_key="base.column_visible_p('user_key')")
  b-taglist(v-if="base.column_visible_p('attack_tag_list') || base.column_visible_p('defense_tag_list')")
    template(v-for="key in ['attack_tag_list', 'defense_tag_list']")
      template(v-if="base.column_visible_p(key)")
        template(v-for="name in membership[key]")
          nuxt-link(:to="{name: 'swars-search', query: {query: new_query(name)}}" @click.native="sound_play_click()")
            b-tag(rounded) {{name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexMembership",
  mixins: [support_child],
  props: {
    membership: { type: Object, required: true },
  },
  methods: {
    new_query(name) {
      return [this.membership.user.key, `tag:${name}`].join(" ")
    },
  },
  computed: {
    has_medal() { return this.base.column_visible_p('medal') },
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

  // メダルがあってタブレット以上なら戦法の左をアイコンのぶんだけずらしておく
  &.has_medal
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
