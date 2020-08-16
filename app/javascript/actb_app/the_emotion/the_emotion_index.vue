<template lang="pug">
.the_emotion_index
  .primary_header
    .header_center_title エモーション一覧
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="$parent.emotion_folder_tab_index" expanded @change="emotion_tab_change_handle")
      template(v-for="e in app.EmotionFolderInfo.values")
        b-tab-item(:label="e.name")

  b-table.is-size-7.mx-2.mt-4(
    v-if="current_emotions.length >= 1"
    :data="current_emotions"
    :mobile-cards="false"
    hoverable
    @click="row => $parent.emotion_test_handle(row)"
    )
    template(slot-scope="props")
      b-table-column.is_clickable(custom-key="name" field="name" label="鍵" @click.native.stop="$parent.emotion_test_handle(props.row)")
        | {{props.row.name}}
      b-table-column(custom-key="message" field="message" label="伝")
        .is_truncate {{props.row.message}}
      b-table-column(custom-key="voice" field="voice" label="声")
        .is_truncate {{props.row.voice}}
      b-table-column(custom-key="operation" label="")
        a.mx-1(@click.stop="$parent.emotion_test_handle(props.row)" v-if="development_p") 再生
        a.mx-1(@click.stop="$parent.emotion_edit_handle(props.row)") 編集
        a.mx-1(@click.stop="emotion_move_to_handle(props.row, 'higher')") ▲
        a.mx-1(@click.stop="emotion_move_to_handle(props.row, 'lower')") ▼
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_emotion_index",
  mixins: [
    support,
  ],
  data() {
    return {
    }
  },
  created() {
    this.emotion_tab_change_handle()
  },
  methods: {
    emotion_tab_change_handle() {
      this.sound_play("click")
      this[`emotion_folder_${this.current_emotion_folder_info.key}_hook`]()
    },
    //////////////////////////////////////////////////////////////////////////////// タブ切り替え時に実行したい内容
    emotion_folder_question_hook() {
    },
    emotion_folder_versus_hook() {
    },
    emotion_folder_trash_hook() {
    },
    ////////////////////////////////////////////////////////////////////////////////
    emotion_move_to_handle(emotion, move_to) {
      this.silent_api_put("emotion_move_to_handle", {emotion_id: emotion.id, move_to: move_to}, e => {
        this.$set(this.app.current_user, "emotions", e.emotions)
        this.sound_play("click")
        this.ok_notice(`並び替えました`)
      })
    },
  },
  computed: {
    current_emotion_folder_info() {
      return this.app.EmotionFolderInfo.fetch(this.$parent.emotion_folder_tab_index)
    },
    current_emotions() {
      return this.app.current_user.emotions.filter(e => e.folder_key === this.current_emotion_folder_info.key)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_emotion_index
  @extend %padding_top_for_secondary_header
  .is_truncate
    width: 7rem
</style>
