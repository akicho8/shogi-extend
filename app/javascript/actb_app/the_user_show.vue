<template lang="pug">
.the_user_show.modal-card
  .modal-card-body.box
    .user_container.is-flex
      figure.image.is-64x64.avatar_image
        img.is-rounded(:src="ov_user_info.avatar_path")
      .user_name.has-text-weight-bold
        | {{ov_user_info.name}}
      a.is-block.is-size-8(:href="twitter_url" :target="target_default" v-if="twitter_url")
        | @{{ov_user_info.twitter_key}}
      .rate_container.has-text-weight-bold(v-if="app.config.rating_display_p")
        | R{{ov_user_info.actb_main_xrecord.rating}}
      .skill_key.has-text-weight-bold.has-text-primary.is-size-3.mt-2
        | {{ov_user_info.actb_main_xrecord.skill_key}}

      win_lose_circle(:info="win_lose_circle_params")

      nav.level.is-mobile.level_nav
        .level-item.has-text-centered(v-if="false")
          div
            p.heading 対戦回数
            p.title {{ov_user_info.actb_main_xrecord.battle_count}}
        .level-item.has-text-centered
          div
            p.heading 連勝数
            p.title {{ov_user_info.actb_main_xrecord.straight_win_count}}
        .level-item.has-text-centered
          div
            p.heading 最多連勝数
            p.title {{ov_user_info.actb_main_xrecord.straight_win_max}}
        .level-item.has-text-centered
          div
            p.heading 最多連敗数
            p.title {{ov_user_info.actb_main_xrecord.straight_lose_max}}
        .level-item.has-text-centered
          div
            p.heading 切断回数
            p.title {{ov_user_info.actb_main_xrecord.disconnect_count}}

      nav.level.is-mobile.level_nav
        .level-item.has-text-centered
          div
            p.heading 投稿問題数
            p.title {{ov_user_info.statistics.active_questions_count}}
        .level-item.has-text-centered
          div
            p.heading 高評価率
            p.title {{float_to_perc2(ov_user_info.statistics.questions_good_rate_average)}} %
        .level-item.has-text-centered
          div
            p.heading 高評価数
            p.title {{ov_user_info.statistics.questions_good_marks_total}}
        .level-item.has-text-centered
          div
            p.heading 低評価数
            p.title {{ov_user_info.statistics.questions_bad_marks_total}}

      .box.description.has-background-white-ter.is-shadowless.is-size-7(v-if="ov_user_info.description" v-html="auto_link(ov_user_info.description)")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_user_show",
  props: {
    ov_user_info: { type: Object, required: true },
  },
  mixins: [
    support,
  ],
  created() {
    // 保存しておけば衝突しないけど、いまいち
    this.app.ov_question_info = null // FIXME: 画面が衝突してしまうため
  },
  computed: {
    win_lose_circle_params() {
      return {
        judge_counts: {
          win:  this.ov_user_info.actb_main_xrecord.win_count,
          lose: this.ov_user_info.actb_main_xrecord.lose_count,
        },
      }
    },
    twitter_url() {
      const v = this.ov_user_info.twitter_key
      if (v) {
        return `https://twitter.com/${v}`
      }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_user_show
  .modal-card-body
    margin: 0rem 1rem
    padding: 2rem 1rem

    .user_container
      flex-direction: column
      align-items: center

      .avatar_image
      .user_name
        margin-top: 0.6rem
      .rate_container
        margin-top: 0rem
      .win_lose_circle
        margin-top: 0.6rem
      .level_nav
        margin-top: 1rem
        .heading
          width: 5rem
        .title
          font-size: $size-6
      .description
        white-space: pre-line
        margin: 0 1rem
</style>
