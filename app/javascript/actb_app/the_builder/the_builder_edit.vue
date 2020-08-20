<template lang="pug">
.the_builder_edit
  ////////////////////////////////////////////////////////////////////////////////
  .primary_header
    b-icon.header_item.with_icon.ljust(icon="arrow-left" @click.native="builder_app.builder_index_handle")
    .header_center_title
      template(v-if="builder_app.question.title")
        | {{builder_app.question.title}}
      template(v-else)
        | {{builder_app.question_new_record_p ? '新規' : '編集'}}
    .header_item.with_text.rjust.has-text-weight-bold(@click="builder_app.question_save_handle" :class="{disabled: !builder_app.save_button_enabled}")
      | {{builder_app.save_button_name}}

  ////////////////////////////////////////////////////////////////////////////////
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="builder_app.tab_index" expanded @change="builder_app.edit_tab_change_handle")
      b-tab-item(label="配置")

      b-tab-item
        template(slot="header")
          span
            | 正解
            b-tag(rounded v-if="builder_app.question.moves_answers.length >= 1") {{builder_app.question.moves_answers.length}}

      b-tab-item(label="情報")

      b-tab-item
        template(slot="header")
          span
            | 検証
            b-tag(rounded v-if="builder_app.valid_count >= 1" type="is-primary") OK

  ////////////////////////////////////////////////////////////////////////////////
  the_builder_edit_haiti(  v-if="builder_app.current_tab_info.key === 'haiti_mode'")
  the_builder_edit_seikai( v-if="builder_app.current_tab_info.key === 'seikai_mode'" ref="the_builder_edit_seikai")
  the_builder_edit_form(   v-if="builder_app.current_tab_info.key === 'form_mode'")
  the_builder_edit_kensho( v-if="builder_app.current_tab_info.key === 'kensho_mode'")
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
