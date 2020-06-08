<template lang="pug">
.the_user_show
  .primary_header
    .header_center_title
    b-icon.header_item.with_icon.ljust(icon="arrow-left" @click.native="app.ov_user_info_close")

  .user_container.is-flex
    figure.image.is-64x64.avatar_image
      img.is-rounded(:src="app.ov_user_info.avatar_path")
    .user_name.has-text-weight-bold
      | {{app.ov_user_info.name}}
    .rate_container
      | R{{app.ov_user_info.actb_current_xrecord.rating}}

    win_lose_circle(:info="win_lose_circle_params")

    nav.level.is-mobile.level_nav
      .level-item.has-text-centered(v-if="false")
        div
          p.heading 対戦回数
          p.title {{app.ov_user_info.actb_current_xrecord.battle_count}}
      .level-item.has-text-centered
        div
          p.heading 連勝数
          p.title {{app.ov_user_info.actb_current_xrecord.rensho_count}}
      .level-item.has-text-centered
        div
          p.heading 最多連勝数
          p.title {{app.ov_user_info.actb_current_xrecord.rensho_max}}
      .level-item.has-text-centered
        div
          p.heading 最多連敗数
          p.title {{app.ov_user_info.actb_current_xrecord.renpai_max}}
      .level-item.has-text-centered
        div
          p.heading 切断回数
          p.title {{app.ov_user_info.actb_current_xrecord.disconnect_count}}

    .box.description.has-background-white-ter.is-shadowless(v-if="app.ov_user_info.description")
      | {{app.ov_user_info.description}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_user_show",
  mixins: [
    support,
  ],
  computed: {
    win_lose_circle_params() {
      return {
        judge_counts: {
          win:  this.app.ov_user_info.actb_current_xrecord.win_count,
          lose: this.app.ov_user_info.actb_current_xrecord.lose_count,
        },
      }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_user_show
  @extend %padding_top_for_primary_header
  .primary_header
    justify-content: space-between

  .user_container
    flex-direction: column
    align-items: center

    .avatar_image
      margin-top: 1.8rem
    .user_name
      margin-top: 0.8rem
    .rate_container
      margin-top: 0rem
    .win_lose_circle
      margin-top: 1rem
    .level_nav
      margin-top: 1rem
      .heading
        width: 5rem
    .description
      white-space: pre-line
      margin: 0 1rem

</style>
