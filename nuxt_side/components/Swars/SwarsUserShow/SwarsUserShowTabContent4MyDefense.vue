<template lang="pug">
.SwarsUserShowTabContent4MyDefense.boxes(v-if="TheApp.tab_index === 4")
  template(v-for="(row, i) in TheApp.info.my_defense_items")
    nuxt-link.box.one_box.two_column(
      :key="`matrix_stat.my_defense_items/${i}`"
      :to="TheApp.tag_search_path(row)"
      @click.native="$sound.play_click()"
      )
      .columns.is-mobile.is-gapless.is-marginless
        .column.is-paddingless.one_box_title
          | {{row.tag.name}}
        .column.is-narrow.is-paddingless.use_rate_block
          .use_rate_label 使用率
          .use_rate_value {{$gs.floatx100_percentage(row.appear_ratio, 1)}}
          .use_rate_unit %
      .columns.is-gapless
        .column.is-paddingless
          WinLoseCircle(:info="row" size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent4MyDefense",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowTabContent4MyDefense
  __css_keep__: 0
</style>
