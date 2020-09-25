<template lang="pug">
a.SwarsUserLinkTo(@click="user_info_show_handle" :class="css_class")
  | {{membership.user.key}} {{membership.grade_info.name}}

  //- b-dropdown.swars_user_link_to
  //-   a(slot="trigger")
  //-     | {{membership.name_with_grade}}
  //-
  //-   b-dropdown-item(@click="user_info_show_handle")
  //-     b-icon(icon="account" size="is-small")
  //-     | プレイヤー情報
  //-
  //-   b-dropdown-item(:href="membership.query_user_url")
  //-     b-icon(icon="magnify" size="is-small")
  //-     | 棋譜検索
  //-
  //-   b-dropdown-item(:href="membership.player_info_path" v-if="membership.player_info_path")
  //-     b-icon(icon="account" size="is-small")
  //-     | プレイヤー情報
  //-
  //-   b-dropdown-item(separator v-if="false")
  //-
  //-   b-dropdown-item(:href="membership.twitter_search_url")
  //-     b-icon(icon="twitter" size="is-small" type="is-info")
  //-     | Twitter検索
  //-
  //-   b-dropdown-item(:href="membership.swars_home_url")
  //-     b-icon(icon="link" size="is-small")
  //-     | ウォーズに飛ぶ
  //-
  //-   b-dropdown-item(:href="membership.google_search_url")
  //-     b-icon(icon="google" size="is-small")
  //-     | ぐぐる
  //-
  //-   b-dropdown-item(v-if="development_p")
  //-     pre
  //-       | {{membership}}
</template>

<script>
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
    //     this.user_info_show_handle()
    //   }
    // }
  },

  methods: {
    user_info_show_handle() {
      this.user_info_show_modal(this.membership.user.key)
    },
  },
  computed: {
    css_class() {
      if (this.membership.judge) {
        return `is-${this.membership.judge.key}`
      }
    },
  },
}
</script>

<style lang="sass">
.SwarsUserLinkTo
  &.is-win
    font-weight: bold
</style>
