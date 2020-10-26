<template lang="pug">
.TrainingApp.the_user_show.modal-card
  .modal-card-body.box
    .delete.page_delete.is-large(@click="delete_click_handle")
    .user_container.is-flex
      figure.image.is-64x64.avatar_image
        img.is-rounded(:src="ov_user_info.avatar_path")
      .user_name.has-text-weight-bold.mt-1
        | {{ov_user_info.name}}
      a.is-block.is-size-8(:href="twitter_url" :target="target_default" v-if="twitter_url")
        | @{{ov_user_info.twitter_key}}
      .skill_key.has-text-weight-bold.is-size-6.mt-1
        span.has-text-danger
          | {{ov_user_info.actb_main_xrecord.skill_key}}
        span.has-text-danger.ml-1(v-if="app.config.rating_display_p")
          | {{rating_format(ov_user_info.actb_main_xrecord.rating)}}

      WinLoseCircle.mt-1(:info="win_lose_circle_params")

      nav.level.is-mobile.level_nav.mt-3
        .level-item.has-text-centered
          div
            p.heading 正解数
            p.title {{ov_user_info.statistics.total_o_count}}
        .level-item.has-text-centered
          div
            p.heading 不正解数
            p.title {{ov_user_info.statistics.total_x_count}}
        .level-item.has-text-centered
          div
            p.heading 正解率
            p.title {{float_to_perc(total_o_rate)}} %

      nav.level.is-mobile.level_nav.mt-3
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

      nav.level.is-mobile.level_nav.mt-2
        .level-item.has-text-centered
          div
            p.heading 投稿問題数
            p.title {{ov_user_info.statistics.active_questions_count}}
        .level-item.has-text-centered
          div
            p.heading 高評価数
            p.title {{ov_user_info.statistics.questions_good_marks_total}}
        .level-item.has-text-centered
          div
            p.heading 低評価数
            p.title {{ov_user_info.statistics.questions_bad_marks_total}}
        .level-item.has-text-centered
          div
            p.heading 高評価率
            p.title {{float_to_perc(ov_user_info.statistics.questions_good_rate_average)}} %

      .box.description.has-background-white-ter.is-shadowless.is-size-7.mt-4(v-if="ov_user_info.description" v-html="auto_link(ov_user_info.description)")
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
  methods: {
    delete_click_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
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
    permalink_url() {
      return this.app.ov_user_url(this.ov_user_info.id)
    },
    total_o_rate() {
      const o = this.ov_user_info.statistics.total_o_count
      const x = this.ov_user_info.statistics.total_x_count
      if ((o + x) === 0) {
        return 0
      } else {
        return o / (o + x)
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
    padding: 1rem 1rem

    .delete
      top: 6px
      left: 22px

    .user_container
      flex-direction: column
      align-items: center

      .skill_key
        margin-top: -0.2rem

      .level_nav
        margin-bottom: 0
        .heading
          width: 4rem
        .title
          font-size: $size-6
      .description
        white-space: pre-line
        padding: 0.75rem
        margin: 0 0rem
</style>
