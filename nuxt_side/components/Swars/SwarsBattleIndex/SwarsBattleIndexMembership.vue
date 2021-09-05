<template lang="pug">
.SwarsBattleIndexMembership
  .icon_with_name
    MembershipMedal(:params="m.medal_params" v-if="m.medal_params")
    SwarsBattleShowUserLink(:membership="m")
  b-taglist
    template(v-for="key in ['attack_tag_list', 'defense_tag_list']")
      template(v-if="base.visible_hash[key]")
        template(v-for="name in m[key]")
          nuxt-link(:to="{name: 'swars-search', query: {query: new_query(name)}}" @click.native="sound_play('click')")
            //- b-tag(rounded :type="key === 'attack_tag_list' ? 'is-danger' : 'is-warning is-light'") {{name}}
            b-tag(rounded) {{name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexMembership",
  mixins: [
    support_child,
  ],
  props: {
    base:       { type: Object, required: true },
    membership: { type: Object, required: true },
  },
  methods: {
    new_query(name) {
      return `${this.m.user.key} tag:${name}`
    },
  },
  computed: {
    m() { return this.membership },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexMembership
  // モバイルのときは縦表示になるので名前を大きくする
  .icon_with_name
    display: flex
    align-items: center
    justify-content: flex-start

    +mobile
      font-size: $size-4
      justify-content: flex-end
    +tablet
      font-size: $size-5

  .tags
    margin-bottom: 0
    +tablet
      margin-left: 1.5rem
    .tag
      margin-bottom: 0

    a
      margin: 0           // 右方向にあるマージを除去
      &:not(:first-child)
        margin-left: 2px  // タグ同士の隙間

    // モバイル時は折り返しありの右より
    +mobile
      flex-wrap: wrap
      justify-content: flex-end
      align-items: center
      align-content: flex-start

  .SwarsBattleShowUserLink
    // &.is-win
    // &.is-lose
    //   color: $text
    //   &:hover
    //     color: $link

.STAGE-development
  .SwarsBattleIndexMembership
    .icon_with_name
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .tags
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
