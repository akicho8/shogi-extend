<template lang="pug">
.SwarsUserShowTabContent1Grade.boxes(v-if="TheApp.tab_index === 1")
  template(v-for="(row, i) in TheApp.info.vs_grade_items")
    .box
      .columns.is-mobile.is-gapless.is-marginless
        .column.is-paddingless.box_head.double_column
          nuxt-link.box_title(:to="TheApp.search_path({'相手の棋力': row.grade_name})" @click.native="sfx_play_click()")
            .vs_mark.is-size-6.has-text-grey-light vs
            .vs_name {{row.grade_name}}
          .box_title_sub
            .use_rate_label 遭遇率
            .use_rate_value {{$gs.floatx100_percentage(row.appear_ratio, 1)}}
            .use_rate_unit %
      .columns.is-gapless
        .column.is-paddingless
          WinLoseCircle(
            :info="row"
            :to_fn="params => TheApp.search_path({'相手の棋力': row.grade_name, ...params})"
            size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent1Grade",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowTabContent1Grade
  __css_keep__: 0
</style>
