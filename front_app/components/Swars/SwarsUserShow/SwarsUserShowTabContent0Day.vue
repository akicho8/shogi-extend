<template lang="pug">
.SwarsUserShowTabContent0Day.tab_content(v-if="base.tab_index === 0")
  template(v-for="(row, i) in base.info.every_day_list")
    nuxt-link.box.one_box.two_column(
      :key="`every_day_list/${i}`"
      :to="base.date_search_path(row)"
      @click.native="sound_play('click')"
      )
      .columns.is-mobile
        .column.is-paddingless
          .one_box_title.has-text-weight-bold.is-size-5
            | {{date_to_custom_format(row.battled_on) + " "}}
            span(:class="base.battled_on_to_css_class(row)")
              | {{date_to_wday(row.battled_on)}}
      .columns.is-mobile
        .column.is-paddingless
          WinLoseCircle(:info="row" size="is-small" narrowed)
        .column.is-paddingless.is-flex
          template(v-for="tag in row.all_tags")
            nuxt-link.tag_wrapper.has-text-weight-bold.is-size-5(
              :to="{name: 'swars-search', query: {query: `${base.info.user.key} tag:${tag.name}`}}"
              )
              | {{tag.name}}
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
</style>
