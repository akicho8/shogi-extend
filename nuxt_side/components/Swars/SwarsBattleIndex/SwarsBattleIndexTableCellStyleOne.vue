<template lang="pug">
span.SwarsBattleIndexTableCellStyleOne
  template(v-if="style_key")
    template(v-if="true")
      //- 同じURLだった場合は移動しない。href があらかじめわかるので別タブで開ける
      nuxt-link.is_hover_only_link_color(:to="{name: 'swars-search', query: {query: new_query}}" @click.native="sfx_play_click()") {{name}}
    template(v-else)
      //- 同じURLでもアクセスする。href がわからない
      a.is_hover_only_link_color(@click="APP.interactive_search({query: new_query})") {{name}}
  template(v-else)
    span.has-text-grey-light
      | ？
</template>

<script>
export default {
  name: "SwarsBattleIndexTableCellStyleOne",
  props: ["style_key", "search_column_name"],
  inject: ["APP"],
  methods: {
  },
  computed: {
    name() {
      return this.APP.StyleInfo.fetch(this.style_key).name
    },
    new_query() {
      if (false) {
        const style_pair = [this.search_column_name, this.style_key].join(":")
        return [this.APP.xi.current_swars_user_key, style_pair].join(" ")
      } else {
        return this.style_key
      }
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexTableCellStyleOne
  __css_keep__: 0
</style>
