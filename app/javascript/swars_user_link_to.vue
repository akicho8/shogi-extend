<template lang="pug">
  span.swars_user_link_to
    b-dropdown(:hoverable="true")
      a(slot="trigger")
        | {{membership.name_with_grade}}
      b-dropdown-item(:has-link="true")
        a(@click="self_window_open(membership.query_user_url)")
          b-icon(icon="magnify" size="is-small")
          span.a_label 棋譜検索
      b-dropdown-item(:has-link="true")
        a(:href="membership.twitter_search_url")
          b-icon(icon="twitter" size="is-small")
          span.a_label Twitter検索
      template(v-if="membership.player_info_path")
        b-dropdown-item(:has-link="true")
          a(@click="self_window_open(membership.player_info_path)")
            b-icon(icon="account" size="is-small")
            span.a_label プレイヤー情報
      b-dropdown-item(:has-link="true")
        a(:href="membership.swars_home_url")
          b-icon(icon="open-in-new" size="is-small")
          span.a_label ウォーズに飛ぶ
      b-dropdown-item(:has-link="true")
        a(:href="membership.google_search_url")
          b-icon(icon="google" size="is-small")
          span.a_label ぐぐる
</template>

<script>
export default {
  props: {
    membership: { required: true },
  },
}
</script>
