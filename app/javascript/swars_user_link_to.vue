<template lang="pug">
  span.swars_user_link_to
    b-dropdown(@click.native.stop="() => {}" :hoverable="false")
      a(slot="trigger")
        | {{membership.name_with_grade}}
      b-dropdown-item(:has-link="true")
        a(@click="js_link_to(membership.query_user_url)")
          b-icon(icon="magnify" size="is-small")
          | &nbsp;
          | 検索
      b-dropdown-item(:has-link="true")
        a(@click="js_link_to(membership.player_info_path)")
          b-icon(icon="account" size="is-small")
          | &nbsp;
          | プレイヤー情報
      b-dropdown-item(:has-link="true")
        a(@click="() => {}" :href="membership.swars_home_url" target="_blank")
          b-icon(icon="open-in-new" size="is-small")
          | &nbsp;
          | ウォーズに移動
      b-dropdown-item(:has-link="true")
        a(@click="() => {}" :href="membership.google_search_url" target="_blank")
          b-icon(icon="google" size="is-small")
          | &nbsp;
          | ぐぐる
      b-dropdown-item(:has-link="true")
        a(@click="() => {}" :href="membership.twitter_search_url" target="_blank")
          b-icon(icon="twitter" size="is-small")
          | &nbsp;
          | Twitter検索
</template>

<script>
export default {
  props: {
    membership: { required: true },
  },
}
</script>

<style lang="sass">
</style>
