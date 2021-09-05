<template lang="pug">
.ActbBuilderEdit
  ////////////////////////////////////////////////////////////////////////////////
  .primary_header
    b-icon.header_item.with_icon.ljust(icon="chevron-left" @click.native="bapp.builder_index_handle")
    .header_center_title
      template(v-if="bapp.question.title")
        | {{bapp.question.title}}
      template(v-else)
        | {{bapp.question_new_record_p ? '新規' : '編集'}}
    .header_item.with_text.rjust.has-text-weight-bold(@click="bapp.question_save_handle" :class="{disabled: !bapp.save_button_enabled}")
      | {{bapp.save_button_name}}

  ////////////////////////////////////////////////////////////////////////////////
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="bapp.tab_index" expanded @input="bapp.edit_tab_change_handle")
      b-tab-item(label="配置")

      b-tab-item
        template(slot="header")
          span
            | 正解
            b-tag(rounded v-if="bapp.question.moves_answers.length >= 1") {{bapp.question.moves_answers.length}}

      b-tab-item(label="情報")

      b-tab-item
        template(slot="header")
          span
            | 検証
            b-tag(rounded v-if="bapp.valid_count >= 1" type="is-primary") OK

  ////////////////////////////////////////////////////////////////////////////////
  ActbBuilderEditHaiti(:base="base" :bapp="bapp"  v-if="bapp.current_tab_info.key === 'haiti_mode'")
  ActbBuilderEditSeikai(:base="base" :bapp="bapp" v-if="bapp.current_tab_info.key === 'seikai_mode'" ref="ActbBuilderEditSeikai")
  ActbBuilderEditForm(:base="base" :bapp="bapp"   v-if="bapp.current_tab_info.key === 'form_mode'")
  ActbBuilderEditKensho(:base="base" :bapp="bapp" v-if="bapp.current_tab_info.key === 'kensho_mode'")
</template>

<script>
import { builder_support } from "./builder_support.js"

export default {
  name: "ActbBuilderEdit",
  mixins: [
    builder_support,
  ],

  data() {
    return {
    }
  },
  watch: {
  },
  computed: {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbBuilderEdit
</style>
