<template lang="pug">
.SwarsUserShowHeadMedal.has-text-centered.has-text-weight-bold(v-if="base.info.medal_list.length >= 1")
  template(v-for="(row, i) in base.info.medal_list")
    span(@click="base.medal_click_handle(row)" :class="{'is-clickable': row.message}")
      template(v-if="row.method === 'tag'")
        b-tag(:key="`medal_list/${i}`" :type="row.type" rounded) {{row.name}}
      template(v-else-if="row.method === 'raw'")
        span.raw(:key="`medal_list/${i}`") {{row.name}}
      template(v-else-if="row.method === 'icon'")
        template(v-if="row.tag_wrap")
          b-tag(:key="`medal_list/${i}`" :type="row.tag_wrap.type" rounded)
            b-icon(:key="`medal_list/${i}`" :icon="row.name" :type="row.type" size="is-small")
        template(v-else)
          b-icon(:key="`medal_list/${i}`" :icon="row.name" :type="row.type" size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowHeadMedal",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowHeadMedal
  margin-top: 0.1rem
  span
    > .tag                // .tag > .icon の場合もあるため最初の .tag だけに適用
      margin: auto 0.1rem
    > .raw
      position: relative
      bottom: -0.1rem     // 絵文字は大きいので若干下げる
      margin: auto 0.1rem
    > .icon
      position: relative
      bottom: -0.152rem
      margin: auto 0.1rem
</style>
