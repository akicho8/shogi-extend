<template lang="pug">
span.SwarsBattleIndexTableCellStyleOne
  template(v-if="style_key")
    template(v-if="true")
      //- 同じURLだった場合は移動しない。href があらかじめわかるので別タブで開ける
      nuxt-link(:to="{name: 'swars-search', query: {query: new_query}}" @click.native="$sound.play_click()") {{name}}
    template(v-else)
      //- 同じURLでもアクセスする。href がわからない
      a(@click="TheApp.interactive_search({query: new_query})") {{name}}
  template(v-else)
    span.has-text-grey-light
      | ？
</template>

<script>
export default {
  name: "SwarsBattleIndexTableCellStyleOne",
  props: ["style_key", "search_column_name"],
  inject: ["TheApp"],
  methods: {
  },
  computed: {
    name() {
      return this.TheApp.StyleInfo.fetch(this.style_key).name
    },
    new_query() {
      const style_pair = [this.search_column_name, this.style_key].join(":")
      return [this.TheApp.xi.current_swars_user_key, style_pair].join(" ")
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexTableCellStyleOne
  a
    color: inherit
    &:hover
      color: $link
</style>
