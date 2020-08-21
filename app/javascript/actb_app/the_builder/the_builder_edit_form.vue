<template lang="pug">
.the_builder_edit_form
  b-field(label="タイトル" label-position="on-border")
    b-input(v-model.trim="bapp.question.title" required)

  b-field(label="ヒント" label-position="on-border" v-if="app.config.hint_enable")
    b-input(v-model.trim="bapp.question.hint_desc")

  b-field.lineage_key(label="種類" label-position="on-border" v-if="bapp.LineageInfo")
    b-select(v-model="bapp.question.lineage_key" expanded)
      option(v-for="row in bapp.LineageInfo.values" :value="row.key") {{row.name}}

  b-field(label="制限時間" label-position="on-border" v-if="app.config.time_limit_sec_enable")
    b-timepicker(v-model="bapp.question.time_limit_clock" icon="clock" :enable-seconds="true" :mobile-native="false")

  b-field(label="解説" label-position="on-border")
    b-input(v-model.trim="bapp.question.description" type="textarea" rows="3")

  b-field(label="難易度" custom-class="is-small" v-if="app.config.difficulty_level_enable")
    b-rate(v-model="bapp.question.difficulty_level" spaced :max="app.config.difficulty_level_max" :show-score="false")

  b-field(label="メッセージ" label-position="on-border" message="問題と一緒に表示する文言です。何手指してほしいかや、ヒントを伝えたいときだけ入力してください。基本未入力でかまいません")
    b-input(v-model.trim="bapp.question.direction_message" placeholder="3手指してください")

  b-field(label="タグ" label-position="on-border")
    //- https://buefy.org/documentation/taginput
    b-taginput(v-model="bapp.question.owner_tag_list" rounded :confirm-key-codes="[13, 188, 9, 32]")

  b-field(v-if="lineage_info.mate_validate_on")
    b-switch(v-model="bapp.question.mate_skip" size="is-small") 最後は無駄合い (なので詰みチェックしない)

  b-collapse.mt-6(:open="source_author_collapse_open_p")
    b-button(slot="trigger" @click="sound_play('click')" slot-scope="props" size="is-small") 作者が他者の場合
    .box.py-5.mt-2
      b-field
        b-switch(v-model="bapp.question.source_about_key" size="is-small" true-value="unknown" false-value="ascertained") 作者不詳

      b-field(label="作者" label-position="on-border")
        b-input(v-model.trim="bapp.question.source_author" placeholder="初代大橋宗桂" :disabled="bapp.question.source_about_key === 'unknown'")

      b-field(label="出典メディア" label-position="on-border")
        b-input(v-model.trim="bapp.question.source_media_name" placeholder="詰パラ")

      b-field(label="出典年月日" label-position="on-border")
        b-datepicker(
          v-model="bapp.question.date_casted_source_published_on"
          :month-names="[1,2,3,4,5,6,7,8,9,10,11,12]"
          :day-names="['日','月','火','水','木','金', '土']"
          :years-range="[-500, 100]"
          :mobile-native="false"
        )

      b-field(label="出典URL" label-position="on-border")
        b-input(v-model.trim="bapp.question.source_media_url" type="url")

  b-field(label="フォルダ" custom-class="is-small" v-if="bapp.FolderInfo")
    b-field.is-marginless
      template(v-for="row in bapp.FolderInfo.values")
        b-radio-button(v-model="bapp.question.folder_key" :native-value="row.key" :type="row.type")
          b-icon(:icon="row.icon" size="is-small")
          span {{row.name}}
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_builder_edit_form",
  mixins: [
    support,
  ],
  data() {
    return {
      source_author_collapse_open_p: null,
    }
  },
  created() {
    this.source_author_collapse_open_p = this.bapp.question.source_author_collapse_open_p
  },
  watch: {
    "question.lineage_key": {
      handler(v) {
        this.sound_play("click")
        this.say(v)
      },
    },
    "question.mate_skip": {
      handler(v) {
        this.sound_play("click")
        this.say(v)
      },
    },
    "question.folder_key": {
      handler(v) {
        const folder_info = this.bapp.FolderInfo.fetch(v)
        this.sound_play("click")
        this.say(folder_info.name)
      },
    },
    "question.difficulty_level": {
      handler(v) {
        this.sound_play("click")
        this.say(v)
      },
    },
    "bapp.question.source_about_key": {
      handler(v) {
        if (v === "unknown") {
          this.say("作者不詳")
        }
        this.sound_play("click")
      },
    },
  },
  computed: {
    question()     { return this.bapp.question                                     },
    lineage_info() { return this.bapp.LineageInfo.fetch(this.question.lineage_key) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_edit_form
  margin: 2.4rem 1.0rem $margin_bottom
  .field:not(:first-child)
    margin-top: 2.2rem
  .help
    color: $grey
    font-size: $size-10
  .b-radio
    font-size: $size-7
</style>
