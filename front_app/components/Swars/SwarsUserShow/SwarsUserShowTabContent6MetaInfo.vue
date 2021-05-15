<template lang="pug">
.SwarsUserShowTabContent6MetaInfo.boxes(v-if="base.tab_index === 6")
  .box.one_box.two_column
    .columns.is-mobile.is-gapless.is-marginless
      .column.is-paddingless.one_box_title
        //- .vs_mark.is-size-6.has-text-grey-light vs
        .vs_name foo
      //- .column.is-narrow.is-paddingless.use_rate_block
      //-   .use_rate_label 遭遇率
      //-   .use_rate_value {{float_to_perc(row.appear_ratio, 1)}}
      //-   .use_rate_unit %
    .columns.is-gapless.is-centered
      .column.is-paddingless
        FriendlyPie(:info="row" size="is-small")

  //- template(v-for="(row, i) in base.info.every_vs_defense_list")
  //-   nuxt-link.box.one_box.two_column(
  //-     :key="`every_vs_defense_list/${i}`"
  //-     :to="base.vs_tag_search_path(row)"
  //-     @click.native="sound_play('click')"
  //-     )
  //-     .columns.is-mobile.is-gapless.is-marginless
  //-       .column.is-paddingless.one_box_title
  //-         .vs_mark.is-size-6.has-text-grey-light vs
  //-         .vs_name {{row.tag.name}}
  //-       .column.is-narrow.is-paddingless.use_rate_block
  //-         .use_rate_label 遭遇率
  //-         .use_rate_value {{float_to_perc(row.appear_ratio, 1)}}
  //-         .use_rate_unit %
  //-     .columns.is-gapless
  //-       .column.is-paddingless
  //-         WinLoseCircle(:info="row" size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent6MetaInfo",
  mixins: [support_child],
  data() {
    return {
      row: [
        { name: "a", value: 1 },
        { name: "b", value: 2 },
      ],
    }
  },
}
</script>

<style lang="sass">
.SwarsUserShowTabContent6MetaInfo
</style>
