<template lang="pug">
span.SwarsBattleIndexTableCellStyleBoth
  SwarsBattleIndexTableCellStyleOne(search_column_name="棋風" :style_key="memberships[0].style_key")
  span.mx-1.has-text-grey-light vs
  SwarsBattleIndexTableCellStyleOne(search_column_name="相手の棋風" :style_key="memberships[1].style_key")
</template>

<script>
export default {
  name: "SwarsBattleIndexTableCellStyleBoth",
  props: ["memberships"],
  inject: ["SW"],
}
</script>

<style lang="sass">
.SwarsBattleIndexTableCellStyleBoth
  __css_keep__: 0
</style>
