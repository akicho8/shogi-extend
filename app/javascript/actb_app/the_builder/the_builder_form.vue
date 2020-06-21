<template lang="pug">
.the_builder_form
  b-field(label="タイトル" label-position="on-border")
    b-input(v-model="$parent.question.title")

  b-field(label="ヒント" label-position="on-border" v-if="app.config.hint_enable")
    b-input(v-model="$parent.question.hint_desc")

  b-field.lineage_key(label="種類" custom-class="is-small" v-if="$parent.LineageInfo")
    b-select(v-model="$parent.question.lineage.key" expanded)
      option(v-for="row in $parent.LineageInfo.values" :value="row.key") {{row.name}}

  b-field(label="制限時間" label-position="on-border")
    b-timepicker(v-model="$parent.question.time_limit_clock" icon="clock" :enable-seconds="true" :mobile-native="false")

  b-field(label="難易度" custom-class="is-small")
    b-rate(v-model="$parent.question.difficulty_level" spaced :max="$parent.start_level_max" :show-score="false")

  b-field(label="フォルダ" custom-class="is-small" v-if="$parent.FolderInfo")
    b-field.is-marginless
      template(v-for="row in $parent.FolderInfo.values")
        b-radio-button(v-model="$parent.question.folder_key" :native-value="row.key" :type="row.type")
          b-icon(:icon="row.icon" size="is-small")
          span {{row.name}}

  b-field(label="解説" label-position="on-border")
    b-input(v-model="$parent.question.description" size="is-small" type="textarea" rows="4")

  b-collapse.mt-5(:open="tashaga_sakusha_p")
    button.button.is-small(slot="trigger" @click="sound_play('click')") 他者が作者の場合
    .box
      b-field(label="作者" label-position="on-border")
        b-input(v-model="$parent.question.other_author" placeholder="初代大橋宗桂")

      b-field(label="出典メディア" label-position="on-border")
        b-input(v-model="$parent.question.source_media_name" placeholder="詰パラ")

      b-field(label="出典年月日" label-position="on-border")
        b-datepicker(v-model="$parent.question.source_published_on" :mobile-native="false")

      b-field(label="出典URL" label-position="on-border")
        b-input(v-model="$parent.question.source_media_url" type="url")
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_builder_form",
  mixins: [
    support,
  ],
  data() {
    return {
    }
  },
  watch: {
    "$parent.question.lineage.key": {
      handler(v) {
        this.sound_play("click")
        this.talk2(v)
      },
    },
    "$parent.question.folder_key": {
      handler(v) {
        const folder_info = this.$parent.FolderInfo.fetch(v)
        this.sound_play("click")
        this.talk2(folder_info.name)
      },
    },
    "$parent.question.difficulty_level": {
      handler(v) {
        this.sound_play("click")
        if (v >= this.$parent.start_level_max && false) {
          v = "MAX"
        }
        this.talk2(v)
      },
    },
  },
  computed: {
    tashaga_sakusha_p() {
      return this.$parent.question.other_author || this.$parent.question.source_media_name || this.$parent.question.source_media_url
    },
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
    font-size: $size-7
  .b-radio
    font-size: $size-7
  .lineage_key
    margin-top: 1.1rem !important // 種類の上が開きすぎているのでせばめる
</style>
