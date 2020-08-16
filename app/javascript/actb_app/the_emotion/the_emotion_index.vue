<template lang="pug">
.the_emotion_index
  .primary_header
    .header_center_title エモーション一覧
    b-icon.header_item.with_icon.rjust(icon="plus" @click.native="$parent.new_handle")
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="$parent.current_tabpos" expanded @change="tab_change_hook")
      template(v-for="e in app.EmotionFolderInfo.values")
        b-tab-item
          template(slot="header")
            span
              | {{e.name}}
              b-tag(rounded)
                | {{folder_records(e).length}}

  b-table.is-size-7.mx-2.mt-4(
    v-if="current_records.length >= 1"
    :data="current_records"
    :mobile-cards="false"
    hoverable
    @click="row => $parent.play_handle(row)"
    )
    template(slot-scope="props")
      b-table-column.is_clickable(custom-key="name" field="name" label="鍵" @click.native.stop="$parent.play_handle(props.row)")
        | {{props.row.name}}
      b-table-column(custom-key="message" field="message" label="伝")
        .is_truncate {{props.row.message}}
      b-table-column(custom-key="voice" field="voice" label="声")
        .is_truncate {{props.row.voice}}
      b-table-column(custom-key="operation" label="")
        a.mx-1(@click.stop="$parent.play_handle(props.row)" v-if="development_p") 再生
        a.mx-1(@click.stop="$parent.edit_handle(props.row)") 編集
        a.mx-1(@click.stop="move_to_handle(props.row, 'lower')") ▼
        a.mx-1(@click.stop="move_to_handle(props.row, 'higher')") ▲
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_emotion_index",
  mixins: [
    support,
  ],
  created() {
    this.tab_change_hook()
  },
  methods: {
    // タブが変更されたときの処理
    tab_change_hook() {
      this.sound_play("click")
      const func = this[`tab_change_hook_for_${this.$parent.current_folder.key}`]
      if (func) {
        func()
      }
    },
    // 上下並び替え
    move_to_handle(record, move_to) {
      this.api_put("emotion_move_to_handle", {emotion_id: record.id, move_to: move_to}, e => {
        this.$set(this.app.current_user, "emotions", e.emotions)
        this.sound_play("click")
      })
    },
    // 指定フォルダに入っているレコード(複数)を返す
    folder_records(folder) {
      return this.app.current_user.emotions.filter(e => e.folder_key === folder.key)
    },
  },
  computed: {
    current_records() {
      return this.folder_records(this.$parent.current_folder)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_emotion_index
  @extend %padding_top_for_secondary_header
  .is_truncate
    max-width: 7rem
</style>
