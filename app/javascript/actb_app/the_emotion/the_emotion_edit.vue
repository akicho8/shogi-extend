<template lang="pug">
.the_emotion_edit
  .primary_header
    .header_item.with_text.ljust(@click="cancel_handle") キャンセル
    .header_center_title
      | エモーション編集
    .header_item.with_text.rjust.has-text-weight-bold.is_clickable(@click="save_handle")
      | {{create_or_upate_name}}

  .mx-5.mt-6
    b-field(label="鍵" label-position="on-border")
      b-input(v-model.trim="$parent.current_record.name")
    b-field(label="伝" label-position="on-border")
      b-input(v-model.trim="$parent.current_record.message")
    b-field(label="声" label-position="on-border")
      b-input(v-model.trim="$parent.current_record.voice")
    b-field(label="フォルダ" custom-class="is-small")
      b-field.is-marginless
        template(v-for="row in app.EmotionFolderInfo.values")
          b-radio-button(v-model="$parent.current_record.folder_key" :native-value="row.key" :type="row.type" size="is-small") {{row.name}}
    b-field
      b-button(icon-left="play" @click="$parent.slap_handle($parent.current_record)" expanded)
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_emotion_edit",
  mixins: [
    support,
  ],
  methods: {
    save_handle() {
      if (this.$parent.current_record.name) {
      } else {
        this.warning_notice("鍵を入力してください")
        return
      }
      if (this.$parent.current_record.message || this.$parent.current_record.voice) {
      } else {
        this.warning_notice("伝か声を入力してください")
        return
      }

      const before_create_or_upate_name = this.create_or_upate_name
      this.api_put("emotion_save_handle", {emotion: this.$parent.current_record}, e => {
        if (e.form_error_message) {
          this.warning_notice(e.form_error_message)
        }
        if (e.emotions) {
          this.$set(this.app.current_user, "emotions", e.emotions)
          this.sound_play("click")
          this.ok_notice(`${before_create_or_upate_name}しました`)

          this.$parent.current_component = "the_emotion_index"
        }
      })
    },

    cancel_handle() {
      this.$parent.current_component = "the_emotion_index"
    },
  },
  computed: {
    create_or_upate_name() {
      if (this.$parent.current_record.id) {
        return "更新"
      } else {
        return "保存"
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_emotion_edit
  @extend %padding_top_for_primary_header
  .field:not(:first-child)
    margin-top: 2rem
  // .help
  //   color: $grey
  //   font-size: $size-10
  // .b-radio
  //   font-size: $size-7
</style>
