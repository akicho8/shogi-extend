<template lang="pug">
.actb.the_question_show.modal-card
  .modal-card-body.box
    //- // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
    .delete.page_delete.is-large(@click="delete_click_handle")

    //- b-button.right_top(icon-left="twitter" size="is-small" type="is-twitter") Tweet

    .has-text-centered
      b-tag.mt-5(:type="question.folder.type" v-if="question.folder.key === 'draft' || question.folder.key === 'trash'")
        | {{question.folder.name}}

      .question_title.is_line_break_on.is-flex.mt-4.mx-6
        span.has-text-weight-bold.is-size-5
          template(v-if="current_user_is_owner_p || app.debug_force_edit_p")
            a(@click="edit_handle(question.id)")
              | {{question.title}}
          template(v-else)
            | {{question.title}}

      .direction_message.is-size-6(v-if="question.direction_message")
        | {{question.direction_message}}

      .mt-3
        //- https://buefy.org/documentation/tag/
        b-field(grouped group-multiline position="is-centered")
          .control
            b-tag.is-clickable(attached @click.native="app.ov_user_info_set(question.user.id)")
              .is-flex
                template(v-if="question.source_author || question.source_about_key === 'unknown'")
                  | 投稿
                template(v-else)
                  | 作者
                .image.is-16x16.avatar_image.ml-1
                  img.is-rounded(:src="question.user.avatar_path")
                .has-text-weight-bold.ml-1 {{question.user.name}}

          .control
            b-tag
              | 出題
              span.has-text-weight-bold.mx-1 {{question.histories_count}}
              | 回

          .control
            b-tag
              | 正解率
              span.has-text-weight-bold.mx-1 {{float_to_perc(question.ox_record.o_rate || 0)}}
              | %

    b-tabs.mt-2(v-model="tab_index" @input="tab_change_handle" expanded)
      b-tab-item(label="配置")
      template(v-for="(e, i) in question.moves_answers")
        b-tab-item(:label="`${i === 0 ? '解' : ''}${i + 1}`")

    .sp_container
      MyShogiPlayer(
        :run_mode="'play_mode'"
        :kifu_body="selected_sfen"
        :flip_if_white="true"
        :start_turn="-1"
        :key_event_capture="false"
        :slider_show="true"
        :controller_show="true"
        :setting_button_show="false"
        :theme="app.config.sp_theme"
        :size="app.config.sp_size"
        @update:play_mode_advanced_moves="play_mode_advanced_moves_set"
        )

    .has-text-centered.mt-1(v-if="tab_index >= 1")
      b-tag(size="is-small")
        span.is_line_break_on
          | {{question.moves_answers[tab_index - 1].moves_human_str}}

    .vote_container.is-flex.mt-4
      the_history_row_vote(:row="new_ov_question_info")

    .mt-6
      b-field(grouped group-multiline position="is-centered")
        .control
          b-tag
            | 種類
            span.has-text-weight-bold.ml-1 {{question.lineage_key}}

        .control
          b-tag
            | 高評価
            span.has-text-weight-bold.mx-1 {{float_to_perc(question.good_rate)}}
            | %

    .mt-5(v-if="question.source_author || question.source_media_name || question.source_media_url")
      b-field(grouped group-multiline position="is-centered")
        template(v-if="question.source_about_key === 'unknown' || question.source_author")
          .control
            b-tag
              | 作者
              span.has-text-weight-bold.ml-1
                template(v-if="question.source_about_key === 'unknown'")
                  | 不詳
                template(v-else)
                  | {{question.source_author}}

        template(v-if="question.source_media_name")
          .control
            b-tag
              | 出典
              span.has-text-weight-bold
                span.ml-1 {{question.source_media_name}}
                span.ml-1(v-if="question.source_published_on") ({{question.source_published_on}})

      template(v-if="question.source_media_url")
        .has-text-centered.mt-0.is-size-7
          span(v-html="auto_link(question.source_media_url)")

      .mt-6
        b-taglist.is-centered(v-if="question.owner_tag_list.length >= 1")
          template(v-for="tag in question.owner_tag_list")
            b-tag {{tag}}
        b-field.is-paddingless.mx-3.append_tag_list_field.mt-3(label="追加タグ" label-position="on-border")
          //- https://buefy.org/documentation/taginput
          b-taginput(v-model="append_tag_list" rounded :confirm-key-codes="[13, 188, 9, 32]" @input="append_tag_list_input_handle")

    .buttons.is-centered.are-small.mt-6
      PiyoShogiButton(:href="piyo_shogi_app_with_params_url")
      KentoButton(tag="a" :href="kento_app_with_params_url" :target="target_default")
      KifCopyButton(@click="kifu_copy_handle") コピー

    .tweet_button_container.buttons.is-centered.mt-6
      TweetButton(:body="tweet_body")

    .box.question_description.has-background-white-ter.is-shadowless.is-size-7.mt-6(v-if="question.description")
      | {{question.description}}

    the_question_show_message.mt-6(:question="question")
</template>

<script>
import { support } from "./support.js"
import the_history_row_vote      from "./the_history/the_history_row_vote.vue"
import the_question_show_message from "./the_question_show_message.vue"

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
  },

  data() {
    return {
      tab_index: 0,
      new_ov_question_info: this.ov_question_info,
      append_tag_list: [],
    }
  },

  beforeCreate() {
    window.history.pushState(this.$options.name, null, "")
  },

  created() {
    // this.$ga.event("open", {event_category: "問題詳細", event_label: this.question.title, value: this.question.good_marks_count})
    window.history.replaceState("", null, this.permalink_url)
  },

  beforeDestroy() {
    window.history.back()
  },

  methods: {
    edit_handle(question_id) {
      this.$emit("close")
      this.app.edit_question_id = question_id
      if (this.app.$refs.builder) {
        this.app.$refs.builder.question_edit()
      } else {
        this.app.builder_handle()
      }
    },

    delete_click_handle() {
      this.sound_play("click")
      this.$emit("close")
    },

    tab_change_handle() {
      // this.sound_play("click")
      this.sp_turn_slider_auto_focus()
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

    kifu_copy_handle() {
      this.sound_play("click")
      this.general_kifu_copy(this.selected_sfen, {to_format: "kif"})
    },

    append_tag_list_input_handle(append_tag_list) {
      this.debug_alert(append_tag_list)
      const params = {
        question_id: this.question.id,
        append_tag_list: append_tag_list,
      }
      this.silent_api_put("append_tag_list_input_handle", params, e => {
        this.debug_alert(e.owner_tag_list)
        this.new_ov_question_info.question.owner_tag_list = e.owner_tag_list
      })
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
      return this.app.ov_question_url(this.question.id)
    },
    tweet_body() {
      return [
        `#${this.question.lineage_key}`,
        ...this.question.owner_tag_list.map(e => `#${e}`),
        this.permalink_url,
      ].join(" ")
    },

    piyo_shogi_app_with_params_url() { return this.piyo_shogi_auto_url({sfen: this.selected_sfen, turn: -1, flip: false, game_name: this.question.title}) },
    kento_app_with_params_url()      { return this.kento_full_url({sfen: this.selected_sfen, turn: -1, flip: false})   },

    // いまログインしている人はこの問題の投稿者か？
    current_user_is_owner_p() {
      return this.app.current_user && this.app.current_user.id === this.question.user.id
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

    .question_title
      justify-content: center
      align-items: center

    .tags
      // .tag
      //   &:first-child
      //     padding-right: 0rem
      //     font-weight: bold
      //     color: $grey
      //   &:not(:first-child)
      //     padding-left: 0.25rem

    // .avatar_image
    //   img
    //     vertical-align: bottom

    .author_name
      flex-direction: row
      justify-content: center
      align-items: center

    .tab-content
      padding: 0

    .sp_container
      margin-top: 1.5rem

    .moves_human_str

    .vote_container
      justify-content: center

      .the_history_row_vote
        .icon_with_counter
          &.bad
            margin-left: 1.5rem
          &.clip
            margin-left: 2rem

    .append_tag_list_field

    .question_description
      white-space: pre-line
      margin: 0 1rem
</style>
