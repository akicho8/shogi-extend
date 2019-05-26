<template lang="pug">
  span.swars_user_link_to
    b-dropdown(@click.native.stop="() => {}" :hoverable="false")
      a(slot="trigger")
        | {{membership.name_with_grade}}
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click.stop="() => {}" :href="membership.query_user_url")
          b-icon(icon="magnify" size="is-small")
          | &nbsp;
          | 検索
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click.stop="() => {}" :href="membership.player_info_path")
          b-icon(icon="account" size="is-small")
          | &nbsp;
          | プレイヤー情報
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click.stop="() => {}" :href="membership.swars_home_url" target="_blank")
          b-icon(icon="open-in-new" size="is-small")
          | &nbsp;
          | ウォーズに移動
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
