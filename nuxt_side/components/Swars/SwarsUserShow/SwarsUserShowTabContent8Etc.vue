<template lang="pug">
.SwarsUserShowTabContent8Etc.boxes(v-if="TheApp.tab_index === 8")
  template(v-for="(row, i) in TheApp.info.etc_items")
    template(v-if="$gs.present_p(row.body) || development_p")
      .box.two_column
        .columns.is-mobile.is-gapless.is-marginless
          .column.is-paddingless.box_head
            nuxt-link.box_title(
              :tag="row.with_search_params ? 'a' : 'div'"
              :to="row.with_search_params ? TheApp.search_path(row.with_search_params) : {}"
              @click.native="row.with_search_params && $sound.play_click()"
              )
              | {{row.name}}
        .columns.is-gapless.is-centered
          .column.is-paddingless.has-text-weight-bold.is-size-1.is-flex.is-justify-content-center.is-flex-direction-column.is-align-items-center
            template(v-if="row.chart_type === 'win_lose_circle'")
              WinLoseCircle(
                v-if="row.body"
                :info="row.body"
                :to_fn="params => TheApp.search_path({...row.with_search_params, ...params})"
                size="is-small")
            template(v-if="row.chart_type === 'bar'")
              FriendlyBar(:info="row")
            template(v-if="row.chart_type === 'pie'")
              FriendlyPie(:info="row")
            template(v-if="row.chart_type === 'simple'")
              nuxt-link.value_block.py-1(
                :class="`is_simple_type-${row.chart_options.simple_type}`"
                :tag="row.with_search_params ? 'a' : 'div'"
                :to="row.with_search_params ? TheApp.search_path(row.with_search_params) : {}"
                @click.native="row.with_search_params && $sound.play_click()"
                )
                template(v-if="row.chart_options.simple_type === 'second'")
                  template(v-if="time_min(row) >= 1")
                    | {{time_min(row)}}
                    span.unit 分
                  | {{time_sec(row)}}
                  span.unit 秒
                template(v-else-if="row.chart_options.simple_type === 'numeric_with_unit'")
                  | {{row.body}}
                  span.unit
                    | {{row.chart_options.unit}}
                template(v-else)
                  | {{row.body}}
            //- .bottom_message(v-if="row.bottom_message")
            //-   | {{row.bottom_message}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent8Etc",
  mixins: [support_child],
  methods: {
    time_min(row) { return Math.floor(row.body / 60) },
    time_sec(row) { return row.body % 60             },
  },
}
</script>

<style lang="sass">
.SwarsUserShowTabContent8Etc
  .value_block
    // color: change_color($primary, $saturation: 40%, $lightness: 50%)
    color: change_color($info, $alpha: 0.8)
    // letter-spacing: 1rem
  .is_simple_type-second, .is_simple_type-numeric_with_unit
    position: relative
    right: -1rem
  .is_simple_type-raw
    __css_keep__: 0
  .unit
    margin: 0 0.5rem
    color: $grey-light
    font-size: $size-3
  .box
    position: relative
  .bottom_message
    color: $grey-light
    font-size: $size-7
    margin-top: 0.25rem

.STAGE-development
  .SwarsUserShowTabContent8Etc
    .value_block
      border: 1px solid hsla(200, 50%, 50%, 1.0)
</style>
