<template lang="pug">
  span.swars_user_link_to
    b-dropdown(@click.native.stop="() => {}" :hoverable="false")
      a(slot="trigger")
        | {{membership.name_with_grade}}
      b-dropdown-item(:has-link="true")
        a(@click.stop.prevent="js_link_to(membership.query_user_url)")
          b-icon2(icon="magnify")
          | &nbsp;
          | 検索
      b-dropdown-item(:has-link="true")
        a(@click.stop.prevent="js_link_to(membership.player_info_path)")
          b-icon2(icon="account")
          | &nbsp;
          | プレイヤー情報
      b-dropdown-item(:has-link="true")
        a(@click.stop="() => {}" :href="membership.swars_home_url" target="_blank")
          b-icon2(icon="open-in-new")
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
