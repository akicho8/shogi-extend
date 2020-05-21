<template lang="pug">
.the_room
  debug_print(:vars="['app.sub_mode', 'app.progress_info', 'app.question_index', 'app.g_mode']" oneline)

  .vs_info.is-flex
    template(v-for="(membership, i) in app.room.memberships")
      .user_block.user_container.is-flex
        template(v-if="membership.rensho_count >= 2")
          .rensho_count
            | {{membership.rensho_count}}連勝中！
        figure.image.is-32x32
          img.is-rounded(:src="membership.user.avatar_path")
        .user_name.has-text-weight-bold
          | {{membership.user.name}}
        .user_quest_index2
          | {{progress_list(membership).length}} / {{app.room.best_questions.length}}
        .user_quest_index
          template(v-if="progress_list2(membership).length === 0")
            | &nbsp;
          template(v-for="ans_result_key in progress_list2(membership)")
            template(v-if="ans_result_key === 'correct'")
              b-icon(icon="checkbox-blank-circle-outline" type="is-danger" size="is-small")
            template(v-if="ans_result_key === 'mistake'")
              b-icon(icon="close" size="is-small" type="is-success")

      template(v-if="i === 0")
        .vs_block.is-1.is-flex.has-text-weight-bold.is-size-4
          | vs

  template(v-if="app.sub_mode === 'deden_mode'")
    .deden_mode_container.has-text-centered
      | {{app.question_index + 1}}問目

  //- template(v-if="app.current_quest_init_sfen")
  template(v-if="app.sub_mode === 'operation_mode' || app.sub_mode === 'correct_mode'")
    the_room_question1(v-if="app.room.game_key === 'game_key1'")
    the_room_question2(v-if="app.room.game_key === 'game_key2'")

  template(v-if="app.sub_mode === 'mistake_mode'")
    .mistake_mode_container.has-text-centered
      | 時間切れ

  template(v-if="development_p")
    .columns
      .column
        .buttons.is-centered
          b-button(@click="app.kotae_sentaku('correct')") 正解
          b-button(@click="app.kotae_sentaku('mistake')") 時間切れ
</template>

<script>
import support from "./support.js"
import dayjs from "dayjs"
import the_room_question1 from "./the_room_question1.vue"
import the_room_question2 from "./the_room_question2.vue"

export default {
  name: "the_room",
  mixins: [
    support,
  ],
  components: {
    the_room_question1,
    the_room_question2,
  },
  created() {
    this.app.lobby_close()
  },
  methods: {
    progress_list(membership) {
      return this.app.progress_info[membership.id] || []
    },
    progress_list2(membership) {
      return _.takeRight(this.progress_list(membership), 8)
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_room
  .deden_mode_container
    font-size: 5rem
  .mistake_mode_container
    font-size: 5rem
  .vs_info
    justify-content: center
    align-items: center
    .user_block
      width: 100%
      .user_quest_index
    .vs_block
      flex-direction: column
      justify-content: center
      align-items: center
</style>
