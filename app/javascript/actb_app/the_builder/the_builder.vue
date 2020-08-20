<template lang="pug">
.the_builder(v-if="builder_form_resource_fetched_p")
  the_builder_index(v-if="!question")

  .the_builder_new_and_edit(v-if="question")
    ////////////////////////////////////////////////////////////////////////////////
    .primary_header
      b-icon.header_item.with_icon.ljust(icon="arrow-left" @click.native="builder_index_handle(true)")
      .header_center_title
        template(v-if="question.title")
          | {{question.title}}
        template(v-else)
          | {{question_new_record_p ? '新規' : '編集'}}
      .header_item.with_text.rjust.has-text-weight-bold(@click="question_save_handle" :class="{disabled: !save_button_enabled}")
        | {{save_button_name}}

    ////////////////////////////////////////////////////////////////////////////////
    .secondary_header
      b-tabs.tabs_in_secondary(v-model="$store.state.builder.tab_index" expanded @change="edit_tab_change_handle")
        b-tab-item(label="配置")

        b-tab-item
          template(slot="header")
            span
              | 正解
              b-tag(rounded v-if="question.moves_answers.length >= 1") {{question.moves_answers.length}}

        b-tab-item(label="情報")

        b-tab-item
          template(slot="header")
            span
              | 検証
              b-tag(rounded v-if="valid_count >= 1" type="is-primary") OK

    ////////////////////////////////////////////////////////////////////////////////
    the_builder_edit_haiti(  v-if="current_tab_info.key === 'haiti_mode'")
    the_builder_edit_seikai( v-if="current_tab_info.key === 'seikai_mode'" ref="the_builder_edit_seikai")
    the_builder_edit_form(   v-if="current_tab_info.key === 'form_mode'")
    the_builder_edit_kensho( v-if="current_tab_info.key === 'kensho_mode'")

  debug_print(v-if="app.debug_read_p")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support } from "./support.js"
import the_builder_index  from "./the_builder_index.vue"
import the_builder_edit_haiti  from "./the_builder_edit_haiti.vue"
import the_builder_edit_seikai from "./the_builder_edit_seikai.vue"
import the_builder_edit_form   from "./the_builder_edit_form.vue"
import the_builder_edit_kensho from "./the_builder_edit_kensho.vue"

import { Question    } from "../models/question.js"
import { LineageInfo } from '../models/lineage_info.js'
import { FolderInfo  } from '../models/folder_info.js'

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "haiti_mode",  name: "配置", },
      { key: "seikai_mode", name: "正解", },
      { key: "form_mode",   name: "情報", },
      { key: "kensho_mode", name: "検証", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
  components: {
    the_builder_index,
    the_builder_edit_haiti,
    the_builder_edit_seikai,
    the_builder_edit_form,
    the_builder_edit_kensho,
  },
  async created() {
    this.$store.state.builder.builder_app = this

    this.app.lobby_unsubscribe()
    this.sound_play("click")

    await this.resource_fetch()

    // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
    if (this.app.edit_question_id) {
      this.question_edit()
      return
    }

    if (this.app.info.warp_to === "builder_haiti" || this.app.info.warp_to === "builder_form") {
      this.builder_new_handle()
      return
    }

    this.builder_index_handle()
  },

  methods: {
  },

  computed: {
    TabInfo() { return TabInfo },

    current_tab_info() {
      return TabInfo.fetch(this.tab_index)
    },

    save_button_name() {
      if (this.question.id) {
        return "更新"
      } else {
        return "保存"
      }
    },

    base_clock() {
      return dayjs("2000-01-01T00:00:00+09:00")
    },

    save_button_enabled() {
      return this.question.moves_answers.length >= 1
    },

    question_new_record_p() {
      this.__assert__(this.question, "this.question != null")
      return this.question.id == null
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder
  .the_builder_new_and_edit
    @extend %padding_top_for_secondary_header
</style>
