<template lang="pug">
.SwarsUserShowTabContent6MetaInfo.boxes(v-if="base.tab_index === 6")
  template(v-for="(row, i) in base.info.etc_list")
    .box.one_box.two_column
      .columns.is-mobile.is-gapless.is-marginless
        .column.is-paddingless.has-text-weight-bold.is-size-5.is-flex.is-justify-content-center
          | {{row.name}}
      .columns.is-gapless.is-centered
        .column.is-paddingless
          FriendlyPie(:info="row.list" size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent6MetaInfo",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowTabContent6MetaInfo
</style>
