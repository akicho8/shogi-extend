<template lang="pug">
.SwarsUserShowTabContentPart.boxes(v-if="TheApp.tab_index === tab_index")
  template(v-for="(row, i) in TheApp.info[var_name]")
    nuxt-link.box.one_box.two_column(
      :key="`tabs/${var_name}/${i}`"
      :to="TheApp[search_func](row)"
      @click.native="$sound.play_click()"
      )
      .columns.is-mobile.is-gapless.is-marginless
        .column.is-paddingless.one_box_title
          template(v-if="vs_mode")
            .vs_mark.is-size-6.has-text-grey-light vs
            .vs_name {{row.tag.name}}
          template(v-else)
            | {{row.tag.name}}
        .column.is-narrow.is-paddingless.use_rate_block
          .use_rate_label {{right_label}}
          .use_rate_value {{$gs.floatx100_percentage(row.appear_ratio, 1)}}
          .use_rate_unit %
      .columns.is-gapless
        .column.is-paddingless
          WinLoseCircle(:info="row" size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContentPart",
  mixins: [support_child],
  props: {
    tab_index:   { type: Number,  required: true, },
    var_name:    { type: String,  required: true, },
    search_func: { type: String,  required: true, },
    right_label: { type: String,  required: true, },
    vs_mode:     { type: Boolean, required: true, },
  },
}
</script>

<style lang="sass">
.SwarsUserShowTabContentPart
  __css_keep__: 0
</style>
