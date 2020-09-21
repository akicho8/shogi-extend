<template lang="pug">
.the_emotion_index
  .primary_header
    .header_center_title エモーション一覧
    b-icon.header_item.with_icon.rjust(icon="plus" @click.native="$parent.new_handle")
    b-dropdown.header_item.with_icon.ljust.px-3(@active-change="sound_play('click')")
      b-icon(slot="trigger" icon="menu")
      b-dropdown-item.px-4(@click.native.stop="import_handle") プリセットインポート
      b-dropdown-item.px-4(@click.native.stop="destroy_all_handle") 全削除
      b-dropdown-item.px-4(@click.native.stop="reset_handle" v-if="development_p") リセット (全削除してプリセットインポート)

  .secondary_header
    b-tabs.tabs_in_secondary(v-model="$parent.current_tabpos" expanded @input="tab_change_hook")
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
    draggable
    @dragstart="dragstart"
    @drop="drop"
    @dragover="dragover"
    @dragleave="dragleave"
    @click="row => $parent.play_handle(row)"
    )
    b-table-column.is_clickable(v-slot="{row}" custom-key="name" field="name" label="鍵" @click.native.stop="$parent.play_handle(row)")
      | {{row.name}}
    b-table-column(v-slot="{row}" custom-key="message" field="message" label="伝")
      .is_truncate {{row.message}}
    b-table-column(v-slot="{row}" custom-key="voice" field="voice" label="声")
      .is_truncate {{row.voice}}
    b-table-column(v-slot="{row}" custom-key="operation" label="")
      a.mx-1(@click.stop="$parent.play_handle(row)" v-if="development_p") 再生
      a.mx-1(@click.stop="$parent.edit_handle(row)") 編集
      a.mx-1(@click.stop="move_to_handle(row, 'lower')") ▼
      a.mx-1(@click.stop="move_to_handle(row, 'higher')") ▲
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
      ////////////////////////////////////////////////////////////////////////////////
      // https://buefy.org/documentation/table#draggable-rows
      dragging_row: null,
      dragging_row_index: null,
    }
  },

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
      this.api_put("emotion_move_to_handle", {record_id: record.id, move_to: move_to}, e => {
        this.$set(this.app.current_user, "emotions", e.emotions)
        this.sound_play("click")
      })
    },
    // 指定フォルダに入っているレコード(複数)を返す
    folder_records(folder) {
      return this.app.current_user.emotions.filter(e => e.folder_key === folder.key)
    },
    // 初期値に戻す
    reset_handle() {
      this.api_put("emotions_reset_handle", {}, e => {
        this.$set(this.app.current_user, "emotions", e.emotions)
        this.sound_play("click")
      })

      // this.$buefy.dialog.confirm({
      //   title: "リセット",
      //   message: `初期値に戻します。既存のエモーションはいったんすべて消えますが、本当によろしいですか？`,
      //   confirmText: "リセットする",
      //   // canCancel: ["outside", "escape"],
      //   cancelText: "キャンセル",
      //   type: "is-danger",
      //   hasIcon: true,
      //   trapFocus: true,
      //   onConfirm: () => {
      //     this.api_put("emotions_reset_handle", {}, e => {
      //       this.$set(this.app.current_user, "emotions", e.emotions)
      //       this.sound_play("click")
      //     })
      //   },
      //   onCancel:  () => { this.ok_notice("キャンセルしました") },
      // })
    },
    destroy_all_handle() {
      this.api_put("emotions_destroy_all_handle", {}, e => {
        this.$set(this.app.current_user, "emotions", e.emotions)
        this.sound_play("click")
      })
    },
    import_handle() {
      this.api_put("emotions_import_handle", {}, e => {
        this.$set(this.app.current_user, "emotions", e.emotions)
        this.sound_play("click")
      })
    },

    ////////////////////////////////////////////////////////////////////////////////
    // https://buefy.org/documentation/table#draggable-rows
    dragstart(payload) {
      this.dragging_row = payload.row
      this.dragging_row_index = payload.index
      payload.event.dataTransfer.effectAllowed = 'copy'
    },
    dragover(payload) {
      payload.event.dataTransfer.dropEffect = 'copy'
      payload.event.target.closest('tr').classList.add('is-selected')
      payload.event.preventDefault()
    },
    dragleave(payload) {
      payload.event.target.closest('tr').classList.remove('is-selected')
      payload.event.preventDefault()
    },
    drop(payload) {
      payload.event.target.closest('tr').classList.remove('is-selected')
      const dropped_on_row_index = payload.index
      if (this.development_p) {
        this.$buefy.toast.open(`Moved ${this.dragging_row.name} from row ${this.dragging_row_index + 1} to ${dropped_on_row_index + 1}`)
      }
      this.api_put("emotion_insert_at_handle", {record_id: this.dragging_row.id, insert_at: dropped_on_row_index}, e => {
        this.$set(this.app.current_user, "emotions", e.emotions)
        // this.sound_play("click")
      })
    },
    ////////////////////////////////////////////////////////////////////////////////

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
