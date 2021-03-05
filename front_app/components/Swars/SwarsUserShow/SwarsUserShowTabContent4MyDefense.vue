<template lang="pug">
.SwarsUserShowTabContent4MyDefense.tab_content(v-if="base.tab_index === 4")
  template(v-for="(row, i) in base.info.every_my_defense_list")
    nuxt-link.box.one_box.two_column(
      :key="`every_my_defense_list/${i}`"
      :to="base.tag_search_path(row)"
      @click.native="sound_play('click')"
      )
      .columns.is-mobile
        .column.is-three-quarters.is-paddingless
          .one_box_title.has-text-weight-bold.is-size-5
            | {{row.tag.name}}
        .column.is-paddingless
          .has-text-right
            span.has-text-grey-light.is-size-7.use_rate_label
              | 使用率
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
  name: "SwarsUserShowTabContent4MyDefense",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowTabContent4MyDefense
</style>
