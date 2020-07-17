<template lang="pug">
.the_builder_form
  b-field(label="タイトル" label-position="on-border")
    b-input(v-model="$parent.question.title" required)

  b-field(label="ヒント" label-position="on-border" v-if="app.config.hint_enable")
    b-input(v-model="$parent.question.hint_desc")

  b-field.lineage_key(label="種類" label-position="on-border" v-if="$parent.LineageInfo")
    b-select(v-model="$parent.question.lineage.key" expanded)
      option(v-for="row in $parent.LineageInfo.values" :value="row.key") {{row.name}}

  b-field(label="制限時間" label-position="on-border" v-if="app.config.time_limit_sec_enable")
    b-timepicker(v-model="$parent.question.time_limit_clock" icon="clock" :enable-seconds="true" :mobile-native="false")

  b-field(label="解説" label-position="on-border")
    b-input(v-model="$parent.question.description" type="textarea" rows="3")

  b-field(label="難易度" custom-class="is-small" v-if="app.config.difficulty_level_max >= 1")
    b-rate(v-model="$parent.question.difficulty_level" spaced :max="app.config.difficulty_level_max" :show-score="false")

  b-field(label="メッセージ" label-position="on-border" message="問題と一緒に表示します。最善手ではない手が答えのときや、ヒントを伝えたいときや、何手指して欲しいか指示したいときなどに入力してください。基本は空でかまいません")
    b-input(v-model="$parent.question.direction_message" placeholder="3手指してください")

  b-field(label="タグ" label-position="on-border")
    //- https://buefy.org/documentation/taginput
    b-taginput(v-model="$parent.question.owner_tag_list" rounded confirm-key-codes="[13, 188, 9, 32]")

  b-collapse.mt-5(:open="$parent.question.source_author_collapse_open_p")
    b-button(slot="trigger" @click="sound_play('click')" slot-scope="props" size="is-small") 作者が他者の場合
    .box.py-5.mt-2
      b-field
        b-switch(v-model="$parent.question.source_about_key" size="is-small" true-value="unknown" false-value="ascertained") 作者不詳

      b-field(label="作者" label-position="on-border")
        b-input(v-model="$parent.question.source_author" placeholder="初代大橋宗桂" :disabled="$parent.question.source_about_key === 'unknown'")

      b-field(label="出典メディア" label-position="on-border")
        b-input(v-model="$parent.question.source_media_name" placeholder="詰パラ")

      b-field(label="出典年月日" label-position="on-border")
        b-datepicker(
          v-model="$parent.question.date_casted_source_published_on"
          :month-names="[1,2,3,4,5,6,7,8,9,10,11,12]"
          :day-names="['日','月','火','水','木','金', '土']"
          :years-range="[-500, 100]"
          :mobile-native="false"
        )

      b-field(label="出典URL" label-position="on-border")
        b-input(v-model="$parent.question.source_media_url" type="url")

  b-field(label="フォルダ" custom-class="is-small" v-if="$parent.FolderInfo")
    b-field.is-marginless
      template(v-for="row in $parent.FolderInfo.values")
        b-radio-button(v-model="$parent.question.folder_key" :native-value="row.key" :type="row.type")
          b-icon(:icon="row.icon" size="is-small")
          span {{row.name}}
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_builder_form",
  mixins: [
    support,
  ],
  watch: {
    "question.lineage.key": {
      handler(v) {
        this.sound_play("click")
        this.say(v)
      },
    },
    "question.folder_key": {
      handler(v) {
        const folder_info = this.$parent.FolderInfo.fetch(v)
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
  },
  computed: {
    question() { return this.$parent.question            },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_form
  margin: 2.4rem 1.0rem $margin_bottom
  .field:not(:first-child)
    margin-top: 2.2rem
  .help
    color: $grey
    font-size: $size-10
  .b-radio
    font-size: $size-7
</style>
