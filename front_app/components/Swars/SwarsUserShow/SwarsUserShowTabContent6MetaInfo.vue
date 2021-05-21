<template lang="pug">
.SwarsUserShowTabContent6MetaInfo.boxes(v-if="base.tab_index === 6")
  template(v-for="(row, i) in base.info.etc_pie_list")
    template(v-if="row.list.length >= 1")
      .box.one_box.two_column
        .columns.is-mobile.is-gapless.is-marginless
          .column.is-paddingless.has-text-weight-bold.is-size-5.is-flex.is-justify-content-center
            | {{row.name}}
        .columns.is-gapless.is-centered
          .column.is-paddingless
            FriendlyPie(:info="row.list" size="is-small")
  template(v-for="(row, i) in base.info.etc_value_list")
    template(v-if="row.value == null && !development_p")
      | foo
    template(v-else)
      .box.one_box.two_column
        .columns.is-mobile.is-gapless.is-marginless
          .column.is-paddingless.has-text-weight-bold.is-size-5.is-flex.is-justify-content-center
            | {{row.name}}
        .columns.is-gapless.is-centered
          .column.is-paddingless.has-text-weight-bold.is-size-1.is-flex.is-justify-content-center
            .value_block.py-3
              template(v-if="row.value == null")
                .has-text-grey-lighter
                  | ？
              template(v-else-if="typeof row.value === 'string'")
                .has-text-grey-lighter
                  | {{row.value}}
              template(v-else)
                div(:class="`is_type-${row.type}`")
                  template(v-if="row.type === 'second'")
                    //- span.unit 最長
                    template(v-if="time_min(row) >= 1")
                      | {{time_min(row)}}
                      span.unit 分
                    template(v-if="time_sec(row) >= 0")
                      | {{time_sec(row)}}
                      span.unit 秒
                  template(v-else-if="row.type === 'numeric_with_unit'")
                    | {{row.value}}
                    span.unit
                      | {{row.unit}}
                  template(v-else)
                    | {{row.value}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent6MetaInfo",
  mixins: [support_child],
  methods: {
    time_min(row) { return Math.floor(row.value / 60) },
    time_sec(row) { return row.value % 60             },
  },
}
</script>

<style lang="sass">
.SwarsUserShowTabContent6MetaInfo
  .value_block
    // color: $primary
    // letter-spacing: 1rem
  .is_type-second, .is_type-numeric_with_unit
    position: relative
    right: -1rem
  .is_type-raw
  .unit
    margin: 0 0.5rem
    color: $grey-light
    font-size: $size-3
</style>
