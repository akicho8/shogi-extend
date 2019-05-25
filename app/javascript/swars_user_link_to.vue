<template lang="pug">
  span.swars_user_link_to
    b-dropdown(@click.native.stop="() => {}" :hoverable="false")
      a(slot="trigger")
        | {{membership.name_with_grade}}
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click.stop="() => {}" :href="membership.query_user_url") 検索
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click.stop="() => {}" :href="membership.player_info_path") プレイヤー情報
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click.stop="() => {}" :href="membership.swars_home_url" target="_blank") ウォーズに移動
</template>

<script>
export default {
  props: {
    membership: { required: true },
  },
}
</script>

<style lang="sass">
// .swars_user_link_to
//   border: 1px solid blue !important
//   background-color: red !important
</style>
