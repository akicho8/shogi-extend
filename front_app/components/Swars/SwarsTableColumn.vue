<template lang="pug">
.SwarsTableColumn
  .icon_with_name.is-inline-block
    MembershipMedal(:params="m.medal_params" v-if="m.medal_params")
    SwarsUserLinkTo(:membership="m")
  b-taglist
    template(v-for="key in ['attack_tag_list', 'defense_tag_list']")
      template(v-if="visible_hash[key]")
        template(v-for="name in m[key]")
          a
            //- a(@click="tactic_show_modal(name)")
            b-tag(rounded) {{name}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "SwarsTableColumn",
  mixins: [
    support,
  ],
  props: {
    visible_hash: { type: Object, required: true },
    membership:   { type: Object, required: true },
  },
  computed: {
    m() { return this.membership },
  },
}
</script>

<style lang="sass">
.SwarsTableColumn
  .icon_with_name
    font-size: $size-4
    +tablet
      font-size: 1rem

  .tags
    // タグのセパレーター
    a:not(:first-child)
      margin-left: 0.125rem

    // 折り返しありの右より
    flex-wrap: wrap
    justify-content: flex-end
    align-items: center
    align-content: flex-start

    // デフォルトが flex なのでデスクトップ以上では横並びにする
    +tablet
      display: inline-flex

      // プレイヤー名との隙間を少しあける
      margin-left: 0.25rem
</style>
