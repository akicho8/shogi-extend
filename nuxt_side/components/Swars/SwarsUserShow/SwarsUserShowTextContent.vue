<template lang="pug">
.SwarsUserShowTextContent(
  :class="`is_simple_type-${info.chart_options.simple_type}`"
  )
  component.a_or_div(
    :is="info.with_search.params ? 'nuxt-link' : 'div'"
    :to="info.with_search.params && TheApp.search_path(info.with_search.params)"
    @click.native="info.with_search.params && sfx_click()"
    )
    //- .text_content_block
    template(v-if="info.chart_options.simple_type === 'second'")
      template(v-if="time_min >= 1")
        | {{time_min}}
        span.unit.min 分
      | {{time_sec}}
      span.unit.second 秒
    template(v-else-if="info.chart_options.simple_type === 'numeric_with_unit'")
      | {{info.body}}
      span.unit
        | {{info.chart_options.unit}}
    template(v-else)
      | {{info.body}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTextContent",
  mixins: [support_child],
  props: {
    info: { type: Object, required: true, },
  },
  computed: {
    time_min() { return Math.floor(this.info.body / 60) },
    time_sec() { return this.info.body % 60             },
  },
}
</script>

<style lang="sass">
.SwarsUserShowTextContent
  // 単位のサイズ
  // 単位があると左にずれて見えるため少し右にずらすと視覚的に中央にあるように見える
  $unit_size: $size-5

  &.is_simple_type-second, &.is_simple_type-numeric_with_unit
    position: relative
    right: calc(-1 * #{$unit_size} * 0.25) // 単位は1文字と仮定して少し右にずらす

  .a_or_div
    padding: 1.0rem 1.0rem

    color: change_color($info, $alpha: 0.8)

    line-height: 1.0

    display: flex
    align-items: flex-end
    justify-content: center
    gap: 0.5rem

    .unit
      color: $grey-light
      font-size: $unit_size

      position: relative
      bottom: 0.25rem           // 単位が下ずはみ出て見えるため上方向に微調整する

.STAGE-development
  .SwarsUserShowTextContent
    border: 1px solid hsla(200, 50%, 50%, 1.0)
    .unit
      border: 1px solid hsla(200, 50%, 50%, 1.0)
</style>
