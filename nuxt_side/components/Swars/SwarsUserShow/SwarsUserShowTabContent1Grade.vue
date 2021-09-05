<template lang="pug">
.SwarsUserShowTabContent1Grade.boxes(v-if="base.tab_index === 1")
  template(v-for="(row, i) in base.info.every_grade_list")
    nuxt-link.box.one_box.two_column(
      :key="`every_grade_list/${i}`"
      :to="base.vs_grade_search_path(row)"
      @click.native="sound_play('click')"
      )
      .columns.is-mobile.is-gapless.is-marginless
        .column.is-paddingless.one_box_title
          .vs_mark.is-size-6.has-text-grey-light vs
          .vs_name {{row.grade_name}}
        .column.is-narrow.is-paddingless.use_rate_block
          .use_rate_label 遭遇率
          .use_rate_value {{float_to_perc(row.appear_ratio, 1)}}
          .use_rate_unit %
      .columns.is-gapless
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
