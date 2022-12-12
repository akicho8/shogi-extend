<template lang="pug">
span.SwarsBattleIndexTableCellStyleBoth
  SwarsBattleIndexTableCellStyleOne(search_column_name="棋風" :membership="memberships[0]")
  span.mx-1.has-text-grey-light vs
  SwarsBattleIndexTableCellStyleOne(search_column_name="相手の棋風" :membership="memberships[1]")
</template>

<script>
export default {
  name: "SwarsBattleIndexTableCellStyleBoth",
  props: ["memberships"],
  inject: ["TheApp"],
}
</script>

<style lang="sass">
.SwarsBattleIndexTableCellStyleBoth
</style>
