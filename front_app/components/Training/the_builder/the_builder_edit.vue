<template lang="pug">
.the_builder_edit
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
  the_builder_edit_haiti(  v-if="bapp.current_tab_info.key === 'haiti_mode'")
  the_builder_edit_seikai( v-if="bapp.current_tab_info.key === 'seikai_mode'" ref="the_builder_edit_seikai")
  the_builder_edit_form(   v-if="bapp.current_tab_info.key === 'form_mode'")
  the_builder_edit_kensho( v-if="bapp.current_tab_info.key === 'kensho_mode'")
</template>

<script>
import { support } from "../support.js"

import the_builder_edit_haiti  from "./the_builder_edit_haiti.vue"
import the_builder_edit_seikai from "./the_builder_edit_seikai.vue"
import the_builder_edit_form   from "./the_builder_edit_form.vue"
import the_builder_edit_kensho from "./the_builder_edit_kensho.vue"

export default {
  name: "the_builder_edit",
  mixins: [
    support,
  ],
  components: {
    the_builder_edit_haiti,
    the_builder_edit_seikai,
    the_builder_edit_form,
    the_builder_edit_kensho,
  },
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
.the_builder_edit
</style>
