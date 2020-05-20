<template lang="pug">
.the_room_question
  .has-text-centered
    .status1
      | {{time_str}}
    .status2
      | {{turn_offset}}手目
  shogi_player(
    :key="`quest_${app.question_index}`"
    ref="main_sp"
    :run_mode="'play_mode'"
    :kifu_body="position_sfen_add(app.current_quest_init_sfen)"
    :summary_show="false"
    :setting_button_show="false"
    :size="'default'"
    :sound_effect="true"
    :volume="0.5"
    :controller_show="true"
    :human_side_key="'both'"
    :theme="'simple'"
    :vlayout="false"
    @update:turn_offset="v => turn_offset = v"
    @update:play_mode_advanced_full_moves_sfen="app.play_mode_advanced_full_moves_sfen_set"
  )
  .has-text-centered.tags_container
    //- p 難易度:{{record.difficulty_level}}
    b-taglist.is-centered
      b-tag(v-if="record.title") {{record.title}}
      b-tag(v-if="record.source_desc") {{record.source_desc}}
      b-tag(v-if="!record.source_desc") {{record.user.name}}作
      b-tag(v-if="record.hint_description") {{record.hint_description}}
      b-tag(v-if="record.difficulty_level && record.difficulty_level >= 1")
        template(v-for="i in record.difficulty_level")
          | ★

    //- | 難易度:{{app.current_best_question.difficulty_level}}
    //- e.time_limit_sec        = 60 * 3
    //- e.difficulty_level      = 5
    //- e.title                 = "(title)"
    //- e.description           = "(description)"
    //- e.hint_description      = "(hint_description)"
    //- e.source_desc           = "(source_desc)"
    //- e.other_twitter_account = "(other_twitter_account)"
</template>

<script>
import support from "./support.js"
import dayjs from "dayjs"

export default {
  name: "the_room",
  mixins: [
    support,
  ],
  data() {
    return {
      turn_offset: null,
      interval_id: null,
      interval_count: null,
    }
  },
  created() {
    this.interval_start()
  },

  beforeDestroy() {
    this.interval_clear()
  },

  methods: {
    interval_start() {
      this.interval_clear()
      this.interval_count = 0
      this.interval_id = setInterval(this.interval_processing, 1000)
    },

    interval_clear() {
      if (this.interval_id) {
        clearInterval(this.interval_id)
        this.interval_id = null
      }
    },

    interval_processing() {
      if (this.app.sub_mode === "solve_mode") {
        this.interval_count += 1
        if (this.rest_seconds === 0) {
          this.app.kotae_sentaku('mistake')
        }
      }
    },
  },

  computed: {
    record() {
      return this.app.current_best_question
    },
    time_str() {
      return dayjs().startOf("year").set("seconds", this.rest_seconds).format("mm:ss")
    },
    rest_seconds() {
      let v = this.time_limit_sec - this.interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },
    time_limit_sec() {
      // if (this.development_p) {
      //   return 3
      // }
      return this.record.time_limit_sec
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_room_question
  .tags_container
    margin-top: 0.7rem
</style>
