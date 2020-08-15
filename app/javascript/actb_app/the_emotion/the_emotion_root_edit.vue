<template lang="pug">
.the_emotion_root_edit
  .primary_header
    .header_item.with_text.ljust(@click="back_handle") キャンセル
    .header_center_title
      | エモーション編集
    .header_item.with_text.rjust.has-text-weight-bold.is_clickable(@click="emotion_save_handle")
      | {{create_or_upate_name}}

  .mx-4.mt-5
    b-field(label="鍵" label-position="on-border")
      b-input(v-model.trim="$parent.current_emotion.name")
    b-field(label="伝" label-position="on-border")
      b-input(v-model.trim="$parent.current_emotion.message")
    b-field(label="声" label-position="on-border")
      b-input(v-model.trim="$parent.current_emotion.voice")
    b-field(label="フォルダ" custom-class="is-small")
      b-field.is-marginless
        template(v-for="row in app.EmotionCategoryInfo.values")
          b-radio-button(v-model="$parent.current_emotion.category_key" :native-value="row.key" :type="row.type" size="is-small") {{row.name}}
    b-field
      b-button(@click="$parent.emotion_test_handle($parent.current_emotion)" expanded) 再生
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_emotion_root_edit",
  mixins: [
    support,
  ],
  data() {
    return {
    }
  },
  created() {
  },
  methods: {
    emotion_save_handle() {
      if (!this.$parent.current_emotion.name) {
        this.warning_notice("トリガーを入力してください")
        return
      }

      const before_create_or_upate_name = this.create_or_upate_name
      this.api_put("emotion_save_handle", {emotion: this.$parent.current_emotion}, e => {
        if (e.form_error_message) {
          this.warning_notice(e.form_error_message)
        }
        if (e.emotion) {
          this.$parent.current_emotion = e.emotion

          this.sound_play("click")
          this.ok_notice(`${before_create_or_upate_name}しました`)

          this.$parent.current_component = "the_emotion_root_index"
        }
      })
    },
    back_handle() {
      this.$parent.current_component = "the_emotion_root_index"
    },
  },
  computed: {
    create_or_upate_name() {
      if (this.$parent.current_emotion.id) {
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
.the_emotion_root_edit
  @extend %padding_top_for_primary_header
  .field:not(:first-child)
    margin-top: 1.5rem
  // .help
  //   color: $grey
  //   font-size: $size-10
  // .b-radio
  //   font-size: $size-7
</style>
