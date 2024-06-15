<template lang="pug">
.SwarsUserShowTabContentPart.boxes(v-if="TheApp.info[var_name] && TheApp.tab_index === tab_index")
  template(v-for="(row, i) in TheApp.info[var_name]")
    nuxt-link.box.one_box.two_column(
      :key="`tabs/${var_name}/${i}`"
      :to="TheApp[search_func](row)"
      @click.native="$sound.play_click()"
      )
      .columns.is-mobile.is-gapless.is-marginless
        template(v-if="row.tag")
          .column.is-paddingless.one_box_title
            template(v-if="vs_mode")
              .vs_mark.is-size-6.has-text-grey-light vs
              .vs_name {{row.tag}}
            template(v-else)
              | {{row.tag}}
        template(v-if="row.appear_ratio")
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
    tab_index: { type: Number,  required: true, },
    var_name:  { type: String,  required: true, },
    vs_mode:   { type: Boolean, required: true, },
  },
  computed: {
    search_func() { return this.vs_mode ? "vs_tag_search_path" : "my_tag_search_path" },
    right_label() { return this.vs_mode ? "遭遇率" : "使用率" },
  },
}
</script>

<style lang="sass">
.SwarsUserShowTabContentPart
  __css_keep__: 0
</style>
