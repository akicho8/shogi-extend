<template lang="pug">
.SwarsUserShowTabContent8Etc.boxes(v-if="TheApp.tab_index === 8")
  template(v-for="(row, i) in TheApp.info.etc_items")
    template(v-if="$gs.present_p(row.body) || development_p")
      .box.two_column
        .columns.is-mobile.is-gapless.is-marginless
          .column.is-paddingless.box_head
            component.box_title(
              :is="row.with_search.params ? 'nuxt-link' : 'div'"
              :to="row.with_search.params && TheApp.search_path(row.with_search.params)"
              @click.native="row.with_search.params && $sound.play_click()"
              )
              | {{row.name}}
        .columns.is-gapless.is-centered
          .column.is-paddingless.has-text-weight-bold.is-size-1.is-flex.is-justify-content-center.is-flex-direction-column.is-align-items-center
            template(v-if="row.chart_type === 'win_lose_circle'")
              WinLoseCircle(
                v-if="row.body"
                :info="row.body"
                :to_fn="params => TheApp.search_path({...row.with_search.params, ...params})"
                size="is-small")
            template(v-if="row.chart_type === 'bar'")
              FriendlyBar(:info="row")
            template(v-if="row.chart_type === 'pie'")
              FriendlyPie(:info="row" :callback_fn="name => pie_click_handle(row, name)")
            template(v-if="row.chart_type === 'simple'")
              component.value_block.py-1.px-2(
                :is="row.with_search.params ? 'nuxt-link' : 'div'"
                :class="`is_simple_type-${row.chart_options.simple_type}`"
                :to="row.with_search.params && TheApp.search_path(row.with_search.params)"
                @click.native="row.with_search.params && $sound.play_click()"
                )
                template(v-if="row.chart_options.simple_type === 'second'")
                  template(v-if="time_min(row) >= 1")
                    | {{time_min(row)}}
                    span.unit.min 分
                  | {{time_sec(row)}}
                  span.unit.second 秒
                template(v-else-if="row.chart_options.simple_type === 'numeric_with_unit'")
                  | {{row.body}}
                  span.unit
                    | {{row.chart_options.unit}}
                template(v-else)
                  | {{row.body}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent8Etc",
  mixins: [support_child],
  methods: {
    time_min(row) { return Math.floor(row.body / 60) },
    time_sec(row) { return row.body % 60             },

    pie_click_handle(row, name) {
      if (row.with_search.key) {
        this.$sound.play_click()
        const params = {[row.with_search.key]: name}
        const path = this.TheApp.search_path({...row.with_search.params, ...params})
        this.$router.push(path)
      }
    },
  },
}
</script>

<style lang="sass">
.SwarsUserShowTabContent8Etc
  // 単位のサイズ
  // 単位があると左にずれて見えるため少し右にずらすと視覚的に中央にあるように見える
  $unit_size: $size-4

  .value_block
    color: change_color($info, $alpha: 0.8)
  .is_simple_type-second, .is_simple_type-numeric_with_unit
    position: relative
    right: calc(-1 * #{$unit_size} * 0.25) // 単位は1文字と仮定して少し右にずらす
  .is_simple_type-raw
    __css_keep__: 0
  .unit
    margin-left: 0.5rem
    color: $grey-light
    font-size: $unit_size
    &.min
      margin-right: 0.5rem
  .box
    position: relative

.STAGE-development
  .SwarsUserShowTabContent8Etc
    .value_block
      border: 1px solid hsla(200, 50%, 50%, 1.0)
    .unit
      border: 1px solid hsla(200, 50%, 50%, 1.0)
</style>
