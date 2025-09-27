<template lang="pug">
.SwarsUserShowTabContent0Day.boxes(v-if="TheApp.tab_index === 0")
  template(v-for="(row, i) in TheApp.info.day_items")
    .box
      .columns.is-mobile.is-gapless.is-marginless
        .column.is-paddingless.box_head.double_column
          nuxt-link.box_title(:to="TheApp.search_path({'日付': $time.format_ymd(row.battled_on)})" @click.native="sfx_click()")
            | {{$time.format_md_or_ymd(row.battled_on) + " "}}
            .ml-1(:class="TheApp.battled_on_to_css_class(row)")
              | ({{$time.format_wday_name(row.battled_on)}})
      .columns.is-mobile.is-gapless
        .column.is-paddingless
          WinLoseCircle(
            :info="row"
            :to_fn="params => TheApp.search_path({'日付': $time.format_ymd(row.battled_on), ...params})"
            size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent0Day",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowTabContent0Day
  __css_keep__: 0
</style>
