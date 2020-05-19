<template lang="pug">
.the_builder_form
  b-field(label="タイトル" label-position="on-border")
    b-input(v-model="$parent.$parent.$parent.question.title")

  b-field(label="説明" label-position="on-border")
    b-input(v-model="$parent.$parent.$parent.question.description" size="is-small" type="textarea" rows="2")

  b-field(label="ヒント" label-position="on-border")
    b-input(v-model="$parent.$parent.$parent.question.hint_description")

  b-field(label="出典" label-position="on-border")
    b-input(v-model="$parent.$parent.$parent.question.source_desc" placeholder="金田秀信作(詰パラ2007.12.1)")

  b-field(label="制限時間" label-position="on-border")
    //- :default-seconds="0" :default-minutes="0"
    b-timepicker(v-model="$parent.$parent.$parent.time_limit_clock" icon="clock" :enable-seconds="true")
    //- b-numberinput(v-model="time_limit_clock" :min="0")
    //- b-numberinput(v-model="time_limit_clock" :min="0")

  label.is-size-7.has-text-weight-bold 難易度
  b-rate(v-model="$parent.$parent.$parent.question.difficulty_level" spaced :max="$parent.$parent.$parent.start_level_max" :show-score="false")

  b-field
    b-radio-button(v-model="$parent.$parent.$parent.question.folder_key" native-value="active")
      b-icon(icon="check")
      span 公開
    b-radio-button(v-model="$parent.$parent.$parent.question.folder_key" native-value="draft" type="is-warning")
      b-icon(icon="lock-outline")
      span 下書き
    b-radio-button(v-model="$parent.$parent.$parent.question.folder_key" native-value="trash" type="is-danger")
      b-icon(icon="trash-can-outline")
      span ゴミ箱
</template>

<script>
import support from "./support.js"

export default {
  name: "the_builder_form",
  mixins: [
    support,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_builder_form
  margin-top: 0.8rem
</style>
