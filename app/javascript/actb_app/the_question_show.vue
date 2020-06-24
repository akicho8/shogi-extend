<template lang="pug">
.actb.the_question_show.modal-card
  .modal-card-body.box
    //- // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
    .delete.is-large(@click="delete_click_handle")

    //- b-button.right_top(icon-left="twitter" size="is-small" type="is-twitter") Tweet

    .has-text-centered
      .question_title.has-text-weight-bold.is-size-4.mt-4 {{question.title}}

      .mt-3
        //- https://buefy.org/documentation/tag/
        b-field(grouped group-multiline position="is-centered")
          .control
            b-taglist.is_clickable(attached @click.native="app.ov_user_info_set(question.user.id)")
              b-tag(type="is-primary")
                template(v-if="question.other_author")
                  | 投稿
                template(v-else)
                  | 作者
              b-tag(type="is-grey") {{question.user.name}}
          .control
            b-taglist(attached)
              b-tag(type="is-primary") 高評価
              b-tag(type="is-grey")
                | {{float_to_perc2(question.good_rate)}} %
          .control
            b-taglist(attached)
              b-tag(type="is-primary") 正解率
              b-tag(type="is-grey")
                template(v-if="question.ox_record.ox_total === 0")
                  | ?
                template(v-else)
                  | {{float_to_perc2(question.ox_record.o_rate)}} %

    b-tabs.mt-2(v-model="tab_index" @change="tab_change_handle" expanded)
      b-tab-item(label="初期配置")
      template(v-for="(e, i) in question.moves_answers")
        b-tab-item(:label="`${i === 0 ? '解' : ''}${i + 1}`")

    .sp_container
      shogi_player(
        :run_mode="'play_mode'"
        :kifu_body="selected_sfen"
        :start_turn="-1"
        :key_event_capture="false"
        :slider_show="true"
        :controller_show="true"
        :setting_button_show="false"
        :theme="'simple'"
        :size="'default'"
        :sound_effect="true"
        :volume="0.5"
        @update:play_mode_advanced_moves="play_mode_advanced_moves_set"
        )

    .vote_container.is-flex.mt-4
      the_history_row_vote(:row="new_ov_question_info")

    .mt-5
      b-field(grouped group-multiline position="is-centered")
        .control
          b-taglist(attached)
            b-tag(type="is-primary") 種類
            b-tag(type="is-grey") {{question.lineage.key}}

        .control
          b-taglist(attached)
            b-tag(type="is-primary") 出題
            b-tag(type="is-grey") {{question.histories_count}}回

        template(v-if="question.other_author")
          .control
            b-taglist(attached)
              b-tag(type="is-primary") 作者
              b-tag(type="is-grey") {{question.other_author}}

        template(v-if="question.source_media_name")
          .control
            b-taglist(attached)
              b-tag(type="is-primary") 出典
              b-tag(type="is-grey")
                | {{question.source_media_name}}
                span.ml-1(v-if="question.source_published_on")
                  | {{question.source_published_on}}

    template(v-if="question.source_media_url")
      .has-text-centered.mt-3
        a(:href="question.source_media_url") {{question.source_media_url}}

    .tweet_button_container.buttons.is-centered.mt-5
      b-button.has-text-weight-bold(rounded icon-left="twitter" size="is-small" type="is-twitter" tag="a" :href="tweet_intent_url(permalink_url)" :target="target_default") ツイート

    .box.question_description.has-background-white-ter.is-shadowless.is-size-7.mt-5(v-if="question.description")
      | {{question.description}}

    the_question_show_message(:question="question")
</template>

<script>
import { support } from "./support.js"
import the_history_row_vote      from "./the_history/the_history_row_vote.vue"
import the_question_show_message from "./the_question_show_message.vue"
import question_author       from "./components/question_author.vue"

export default {
  name: "the_question_show",
  mixins: [
    support,
  ],

  props: {
    ov_question_info: { type: Object, required: true },
  },

  components: {
    the_history_row_vote,
    the_question_show_message,
    question_author,
  },

  data() {
    return {
      tab_index: 0,
      new_ov_question_info: this.ov_question_info,
    }
  },

  beforeCreate() {
    window.history.pushState(this.$options.name, null, "")
  },

  created() {
    window.history.replaceState("", null, this.permalink_url)
  },

  beforeDestroy() {
    window.history.back()
  },

  methods: {
    delete_click_handle() {
      this.sound_play("click")
      this.$emit("close")
    },

    tab_change_handle() {
      // this.sound_play("click")
    },

    play_mode_advanced_moves_set(moves) {
      if (this.question.moves_valid_p(moves)) {
        this.sound_play("o")
        this.ok_notice("正解")
      }
    },

    // 指定インデックスの解のSFENを返す
    answer_sfen_for(index) {
      return this.question.answer_sfen_list[index]
    },
  },
  computed: {
    selected_sfen() {
      if (this.tab_index === 0) {
        return this.question.init_sfen
      } else {
        return this.answer_sfen_for(this.tab_index - 1)
      }
    },
    question() {
      return this.new_ov_question_info.question
    },
    permalink_url() {
      const url = new URL(location)
      url.searchParams.set("question_id", this.question.id)
      return url.toString()
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_question_show
  &.modal-card
    .modal-card-body
      padding: 0 0 0.5rem

    .right_top
      position: absolute
      top: 0
      right: 0

    .tag
      font-weight: bold

    .tab-content
      padding: 0

    .sp_container
      margin-top: 1.5rem

    .vote_container
      justify-content: center

      .the_history_row_vote
        .icon_with_counter
          &.bad
            margin-left: 1.5rem
          &.clip
            margin-left: 2rem

    .question_description
      white-space: pre-line
      margin: 0 1rem
</style>
