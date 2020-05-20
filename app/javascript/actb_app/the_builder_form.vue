<template lang="pug">
.the_builder_form
  b-field(label="タイトル" label-position="on-border")
    b-input(v-model="$parent.question.title")

  b-field(label="説明" label-position="on-border")
    b-input(v-model="$parent.question.description" size="is-small" type="textarea" rows="4")

  b-field(label="ヒント" label-position="on-border")
    b-input(v-model="$parent.question.hint_description")

  b-field(label="出典" label-position="on-border" message="他者作品の場合に記入する")
    b-input(v-model="$parent.question.source_desc" placeholder="初代大橋宗桂作(詰パラ2020.4.1)")

  b-field(label="制限時間" label-position="on-border")
    b-timepicker(v-model="$parent.time_limit_clock" icon="clock" :enable-seconds="true")

  b-field(label="難易度" custom-class="is-small")
    b-rate(v-model="$parent.question.difficulty_level" spaced :max="$parent.start_level_max" :show-score="false")

  b-field(label="種類" custom-class="is-small")
    b-field.is-marginless
      template(v-for="row in LineageInfo.values")
        b-radio-button(v-model="$parent.question.lineage.key" :native-value="row.key" :type="row.type") {{row.name}}

  b-field(label="フォルダ" custom-class="is-small")
    b-field.is-marginless
      template(v-for="row in FolderInfo.values")
        b-radio-button(v-model="$parent.question.folder_key" :native-value="row.key" :type="row.type")
          b-icon(:icon="row.icon" size="is-small")
          span {{row.name}}
</template>

<script>
import support from "./support.js"

import MemoryRecord from 'js-memory-record'

class LineageInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "詰将棋",     type: "is-primary", },
      { key: "実戦詰め筋", type: "is-primary", },
      { key: "手筋",       type: "is-primary", },
      { key: "必死",       type: "is-primary", },
      { key: "必死逃れ",   type: "is-primary", },
      { key: "定跡",       type: "is-primary", },
      { key: "秘密",       type: "is-danger",  },
    ]
  }
}

class FolderInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "active", name: "公開",   icon: "check",             type: "is-primary", },
      { key: "draft",  name: "下書き", icon: "lock-outline",      type: "is-warning", },
      { key: "trash",  name: "ゴミ箱", icon: "trash-can-outline", type: "is-danger",  },
    ]
  }
}

export default {
  name: "the_builder_form",
  mixins: [
    support,
  ],
  data() {
    return {
    }
  },

  created() {
  },

  watch: {
    "$parent.question.lineage.key": {
      handler(v) {
        this.sound_play("click")
        this.talk(v, {rate: 1.5})
      },
    },
    "$parent.question.folder_key": {
      handler(v) {
        const folder_info = FolderInfo.fetch(v)
        this.sound_play("click")
        this.talk(folder_info.name, {rate: 1.5})
      },
    },
    "$parent.question.difficulty_level": {
      handler(v) {
        this.sound_play("click")
        if (v >= this.$parent.start_level_max) {
          v = "MAX"
        }
        this.talk(v, {rate: 1.5})
      },
    },
  },

  computed: {
    FolderInfo()  { return FolderInfo  },
    LineageInfo() { return LineageInfo },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_builder_form
  margin: 2.4rem 0.8rem
  .field:not(:first-child)
    margin-top: 2rem
  .help
    font-size: 0.7rem
  .b-radio
    font-size: $size-7
</style>
