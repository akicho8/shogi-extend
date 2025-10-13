<template lang="pug">
.SwarsUserShowTabContentPart.boxes(v-if="TheApp.info[var_name] && TheApp.tab_index === tab_index")
  template(v-for="(row, i) in TheApp.info[var_name]")
    .box
      .columns.is-mobile.is-gapless.is-marginless
        .column.is-paddingless.box_head.double_column
          template(v-if="row.tag")
            nuxt-link.box_title(:to="TheApp.search_path({[tag_key]: row.tag})" @click.native="sfx_click()")
              template(v-if="vs_mode")
                .vs_mark.is-size-6.has-text-grey-light vs
                .vs_name {{row.tag}}
              template(v-else)
                | {{row.tag}}
          template(v-if="row.appear_ratio")
            .box_title_sub
              .use_rate_label {{right_label}}
              .use_rate_value {{$GX.floatx100_percentage(row.appear_ratio, 1)}}
              .use_rate_unit %
      .columns.is-gapless
        .column.is-paddingless
          WinLoseCircle(
            :info="row"
            :to_fn="params => TheApp.search_path({[tag_key]: row.tag, ...params})"
            size="is-small"
          )
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
    tag_key()     { return this.vs_mode ? "vs-tag" : "tag"    },
    right_label() { return this.vs_mode ? "遭遇率" : "使用率" },
  },
}
</script>

<style lang="sass">
.SwarsUserShowTabContentPart
  __css_keep__: 0
</style>
