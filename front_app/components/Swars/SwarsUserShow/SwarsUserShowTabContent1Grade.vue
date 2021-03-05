<template lang="pug">
.SwarsUserShowTabContent1Grade.tab_content(v-if="base.tab_index === 1")
  template(v-for="(row, i) in base.info.every_grade_list")
    nuxt-link.box.one_box.two_column(
      :key="`every_grade_list/${i}`"
      :to="base.vs_grade_search_path(row)"
      @click.native="sound_play('click')"
      )
      .columns.is-mobile
        .column.is-three-quarters.is-paddingless
          .one_box_title
            span.has-text-weight-bold.is-size-6.vs_mark.has-text-grey-light
              | vs
            span.has-text-weight-bold.is-size-5.vs_name
              | {{row.grade_name}}
        .column.is-paddingless
          .has-text-right
            span.has-text-grey-light.is-size-7.use_rate_label
              | 遭遇率
            span.use_rate
              | {{float_to_perc(row.appear_ratio, 1)}}
            span.has-text-grey-light.is-size-7.use_rate_unit
              | %
      .columns
        .column.is-paddingless
          WinLoseCircle(:info="row" size="is-small")
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
</style>
