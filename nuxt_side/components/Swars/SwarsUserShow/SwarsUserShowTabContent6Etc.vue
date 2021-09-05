<template lang="pug">
.SwarsUserShowTabContent6Etc.boxes(v-if="base.tab_index === 6")
  template(v-for="(row, i) in base.info.etc_list")
    template(v-if="present_p(row.body) || development_p")
      .box.one_box.two_column
        .columns.is-mobile.is-gapless.is-marginless
          .column.is-paddingless.has-text-weight-bold.is-size-5.is-flex.is-justify-content-center
            | {{row.name}}
        .columns.is-gapless.is-centered
          .column.is-paddingless.has-text-weight-bold.is-size-1.is-flex.is-justify-content-center
            template(v-if="row.type1 === 'bar'")
              FriendlyBar(:info="row")
            template(v-if="row.type1 === 'pie'")
              FriendlyPie(:info="row")
            template(v-if="row.type1 === 'simple'")
              .value_block.py-1(:class="`is_type2-${row.type2}`")
                //- template(v-if="row.body == null")
                //-   .has-text-grey-lighter
                //-     | ？
                //- template(v-else-if="typeof row.body === 'string'")
                //-   .has-text-grey-lighter
                //-     | {{row.body}}
                //- template(v-else)
                template(v-if="row.type2 === 'second'")
                  //- span.unit 最長
                  template(v-if="time_min(row) >= 1")
                    | {{time_min(row)}}
                    span.unit 分
                  | {{time_sec(row)}}
                  span.unit 秒
                template(v-else-if="row.type2 === 'numeric_with_unit'")
                  | {{row.body}}
                  span.unit
                    | {{row.unit}}
                template(v-else)
                  | {{row.body}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent6Etc",
  mixins: [support_child],
  methods: {
    time_min(row) { return Math.floor(row.body / 60) },
    time_sec(row) { return row.body % 60             },
  },
}
</script>

<style lang="sass">
.SwarsUserShowTabContent6Etc
  .value_block
    // color: change_color($primary, $saturation: 40%, $lightness: 50%)
    color: change_color($info, $alpha: 0.8)
    // letter-spacing: 1rem
  .is_type2-second, .is_type2-numeric_with_unit
    position: relative
    right: -1rem
  .is_type2-raw
  .unit
    margin: 0 0.5rem
    color: $grey-light
    font-size: $size-3
</style>
