<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 部屋に入る
      b-tag.mx-2.has-text-weight-bold(type="is-success" v-if="base.ac_room && false") 入室中
    b-button(@click="base.room_url_copy_handle" icon-left="link" size="is-small" rounded v-if="present_p(base.ac_room)") 部屋のリンク
  .modal-card-body
    template(v-if="true || !base.ac_room")
      template(v-if="room_code_field_locked")
        b-field(key="room_code_field_locked_false")
          .control
            b-button.has-text-weight-bold(@click="room_code_show_toggle_handle" icon-left="lock" :disabled="present_p(base.ac_room)")
      template(v-else)
        b-field(label="合言葉" label-position="on-border" key="room_code_field_locked_true")
          b-input.new_room_code(v-model.trim="new_room_code" :disabled="present_p(base.ac_room)" ref="new_room_code")
      b-field(label="ハンドルネーム" label-position="on-border")
        b-input.new_user_name(v-model.trim="new_user_name" :disabled="present_p(base.ac_room)")

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 閉じる
    template(v-if="base.ac_room")
      b-button.leave_button(@click="leave_handle" type="is-danger") 退室
    template(v-else)
      b-button.entry_button(@click="entry_handle" type="is-primary") 入室
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

const ROOM_ENTRY_THEN_MODAL_CLOSE = true  // 入室後にモーダルを閉じるか？ (閉じると「部屋のリンク」がコピーできない)
const ROOM_CODE_ALWAYS_SHOW       = true  // 合言葉は表示しっぱなしにするか？

export default {
  name: "RoomSetupModal",
  mixins: [support_child],
  data() {
    return {
      new_room_code: this.base.room_code,
      new_user_name: this.base.user_name,
      room_code_field_locked: null,
    }
  },
  created() {
    this.room_code_field_lock()
  },
  mounted() {
    this.desktop_focus_to(this.$refs.new_room_code)
  },
  methods: {
    leave_handle() {
      this.$sound.play_click()
      if (this.base.ac_room) {
        // this.toast_ok("退室しました")
        this.base.room_destroy()
      } else {
        this.toast_warn("今は部屋の外です")
      }
    },
    room_code_show_toggle_handle() {
      this.$sound.play_click()
      this.room_code_field_unlock()
    },
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    entry_handle() {
      this.$sound.play_click()

      this.new_room_code = _.trim(this.new_room_code)
      this.new_user_name = _.trim(this.new_user_name)

      if (this.blank_p(this.new_room_code)) {
        this.toast_warn("合言葉を入力してください")
        return
      }

      if (this.base.handle_name_invalid_then_toast_warn(this.new_user_name)) {
        return
      }

      this.base.room_create_by(this.new_room_code, this.new_user_name)
      this.room_code_field_lock()

      if (ROOM_ENTRY_THEN_MODAL_CLOSE) {
        this.$emit("close")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 鍵有効 (合言葉が入力済みのとき)
    room_code_field_lock() {
      if (ROOM_CODE_ALWAYS_SHOW) {
        return
      }
      this.room_code_field_locked = this.present_p(this.base.room_code)
    },
    // 鍵解除
    room_code_field_unlock() {
      this.room_code_field_locked = false
    },
  },
}
</script>

<style lang="sass">
.RoomSetupModal
  +modal_width(320px)

  .modal-card-body
    padding: 1.5rem
    li:not(:first-child)
      margin-top: 0.75rem

  .field:not(:last-child)
    margin-bottom: 1.5rem
</style>
