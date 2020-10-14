<template lang="pug">
.SwarsBattleIndexMembership
  .icon_with_name.is-inline-block
    MembershipMedal(:params="m.medal_params" v-if="m.medal_params")
    SwarsBattleIndexMembershipUserLinkTo(:membership="m")
  b-taglist
    template(v-for="key in ['attack_tag_list', 'defense_tag_list']")
      template(v-if="base.visible_hash[key]")
        template(v-for="name in m[key]")
          nuxt-link(:to="{name: 'swars-search', query: {query: new_query(name)}}" @click.native="sound_play('click')")
            b-tag(rounded) {{name}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "SwarsBattleIndexMembership",
  mixins: [
    support,
  ],
  props: {
    base:       { type: Object, required: true },
    membership: { type: Object, required: true },
  },
  methods: {
    new_query(name) {
      return `${this.m.user.key} tag:${name}`
    },
    // click_handle(name) {
    //   // this.base.interactive_search({query: this.new_query(name)})
    //   // this.$router.push({name: 'swars-search', query: {query: this.new_query(name)}}, () => {
    //   //   // this.sound_play('click')
    //   // }, () => {
    //   //   // かならず失敗するのはどういうこと？？？
    //   //   // this.toast_ng("NG")
    //   // })
    // },
  },
  computed: {
    m() { return this.membership },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexMembership
  .icon_with_name
    +mobile
      font-size: $size-4

  .tags
    .tag
      margin: 0              // 右方向にあるマージを除去
      &:not(:first-child)
        margin-left: 0.25rem // タグ同士の隙間

    // モバイル時は折り返しありの右より
    flex-wrap: wrap
    justify-content: flex-end
    align-items: center
    align-content: flex-start

    // デスクトップ以上で1行表示
    +desktop
      display: inline-flex  // inlineにするとそのまま名前の右配置になる
      margin-left: 0.25rem  // 横並びなのでプレイヤー名との隙間を少しあける

    // これを指定しないとモバイルのときタグのしたに隙間がなくなる
    +mobile
      margin-bottom: 0rem
</style>
