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
              @click.native="row.with_search.params && sfx_click()"
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
              SwarsUserShowTextContent(:info="row")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowTabContent8Etc",
  mixins: [support_child],
  methods: {
    pie_click_handle(row, name) {
      if (row.with_search.key) {
        this.sfx_click()
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
  __css_keep__: 0
</style>
