<template lang="pug">
.the_result_membership.is-flex
  //////////////////////////////////////////////////////////////////////////////// ○連勝
  .rensho_renpai.is-size-8.has-text-weight-bold
    template(v-if="record.rensho_count >= 1")
      .rensho_count {{record.rensho_count}}連勝中！
    template(v-else-if="record.renpai_count >= 1")
      .renpai_count {{record.renpai_count}}連敗中！
    template(v-else)
        | &nbsp;

  //////////////////////////////////////////////////////////////////////////////// アバターと名前
  figure.image
    img.is-rounded(:src="membership.user.avatar_path")
  .user_name.has-text-weight-bold
    | {{membership.user.name}}

  ////////////////////////////////////////////////////////////////////////////////
  .user_quest_index.has-text-weight-bold.is-size-4
    | {{mi.b_score}} / {{app.config.b_score_max_for_win}}

  ////////////////////////////////////////////////////////////////////////////////
  .user_rating.has-text-weight-bold(v-if="app.config.rating_display_p")
    | {{record.rating}}
    span.udemae_last_diff.has-text-danger(v-if="record.udemae_last_diff > 0")
      | (+{{record.udemae_last_diff}})
    span.udemae_last_diff.has-text-success(v-if="record.udemae_last_diff < 0")
      | ({{record.udemae_last_diff}})

  .progress_container.mt-1
    the_result_membership_progress(:record="record")

  .battle_continue_container.has-text-weight-bold
    template(v-if="app.battle_continue_tap_counts[membership.id]")
      | 再戦希望
    template(v-else)
      | &nbsp;
</template>

<script>
import { support } from "./support.js"
import the_result_membership_progress from "./the_result_membership_progress"

export default {
  mixins: [
    support,
  ],
  components: {
    the_result_membership_progress,
  },
  props: {
    membership: { type: Object, required: true, },
  },
  created() {
  },
  computed: {
    mi() {
      return this.app.member_infos_hash[this.membership.id]
    },
    record() {
      return this.membership.user.actb_master_xrecord
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_result_membership
  // 縦配置
  flex-direction: column
  justify-content: center
  align-items: center

  // 左右大きさがぶれないように大きさを共通にする
  min-width: 12rem

  .rensho_count
    color: $danger
  .renpai_count
    color: $success

  // avatar
  img
    width: 32px
    height: 32px

  .udemae_last_diff
    margin-left: 0.1rem

  .progress_container
    width: 12rem
</style>
