<template lang="pug">
b-dropdown.swars_user_link_to(:hoverable="false")
  a.swars_user_name_with_grade(slot="trigger")
    | {{membership.name_with_grade}}

  b-dropdown-item(@click="click_handle")
    b-icon(icon="account" size="is-small")
    span.a_label プレイヤー情報

  b-dropdown-item(:has-link="true")
    a(@click="self_window_open(membership.query_user_url)")
      b-icon(icon="magnify" size="is-small")
      span.a_label 棋譜検索

  b-dropdown-item(:has-link="true")
    a(:href="membership.twitter_search_url")
      b-icon(icon="twitter" size="is-small" type="is-info")
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

  b-dropdown-item(v-if="development_p")
    pre
      | {{membership}}

  //- script#user_info_template(type="text/x-template")
  //-   .modal-card.is-size-7(style="width: auto")
  //-     .modal-card-head
  //-       .modal-card-title {{user_key}}
  //-     .modal-card-body
  //-       OK
  //-       canvas#main_canvas(ref="main_canvas")
  //-     .modal-card-foot
  //-       button.button(type="button" @click="$parent.close()") 閉じる
</template>

<script>

// import user_info_show from "./user_info_show.vue"

export default {
  props: {
    membership: { required: true },
  },

  data() {
    return {
    }
  },

  mounted() {
    // if (this.development_p) {
    //   if (!window.PlayerInfoComponentShowOnce) {
    //     window.PlayerInfoComponentShowOnce = true
    //     this.click_handle()
    //   }
    // }
  },

  methods: {
    click_handle() {
      this.user_info_show_modal(this.membership.user.key)
    },
  },
}
</script>

<style lang="sass">
  @import "stylesheets/bulma_init.scss"
  .swars_user_link_to
</style>
