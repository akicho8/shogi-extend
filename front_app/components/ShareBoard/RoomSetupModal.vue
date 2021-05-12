<template lang="pug">
.modal-card.RoomSetupModal
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold.is-flex.is-align-items-center.is-flex-grow-0
      | 部屋に入る
      b-tag.mx-2.has-text-weight-bold(type="is-success" v-if="base.ac_room") 入室中

  section.modal-card-body
    .content
      ol
        li
          | 同じ合言葉を設定した人と部屋を共有します
        li
          | 合言葉を設定したら同じ合言葉を相手にも伝えてください
          .has-text-grey.is-size-7
            | メニューにある「合言葉だけを含むURL」を伝えてもよし
          .is-flex.is-align-items-center(v-if="false")
            b-button(@click="base.room_code_url_copy_handle" icon-left="clipboard-plus-outline" outlined :disabled="!base.room_code") 合言葉だけを含むURL
            span.ml-1 を伝えてもよし
        li(v-if="false")
          | <b>待った</b>や<b>反則の取り消し</b>は合意の上、当人が下の左矢印で局面を戻して指し直してください
        li
          | 基本的に盤の同期は
          b.is-size-5.mx-1 指したときだけ！
          | ← これ重要
          .has-text-grey.is-size-7
            | あと「初期配置に戻す」と「1手戻す」のときも同期する

        li(v-if="false")
          | 指し手のログの行をタップするとそのときの局面にワープします
          .has-text-grey.is-size-7
            | 何か問題が起きたとき用で基本的には使わないでよい

    template(v-if="!base.ac_room")
      template(v-if="room_code_field_locked")
        b-field(label="合言葉 (設定済み)" custom-class="is-small" key="room_code_field_locked_false")
          .control
            b-button.has-text-weight-bold(@click="room_code_show_toggle_handle" icon-left="lock" type="is-danger") 変更
      template(v-else)
        b-field(label="合言葉" label-position="on-border" key="room_code_field_locked_true")
          b-input.new_room_code(v-model="new_room_code")

      b-field(label="ハンドルネーム" label-position="on-border" message="ハンドルネームはあとから変更できますが順番設定後は再度順番設定が必要です")
        b-input.new_user_name(v-model="new_user_name")

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    template(v-if="base.ac_room")
      b-button.leave_button(@click="leave_handle" type="is-primary") 退室
    template(v-else)
      b-button.entry_button(@click="entry_handle" type="is-primary") 入室
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

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
  methods: {
    leave_handle() {
      this.sound_play("click")
      if (this.base.ac_room) {
        this.toast_ok("退室しました")
        this.base.room_destroy()
      } else {
        this.toast_warn("今は部屋の外です")
      }
    },
    room_code_show_toggle_handle() {
      this.sound_play("click")
      this.room_code_field_unlock()
    },
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    entry_handle() {
      this.sound_play("click")

      this.new_room_code = _.trim(this.new_room_code)
      this.new_user_name = _.trim(this.new_user_name)

      if (!this.new_room_code) {
        this.toast_ng("合言葉を入力してください")
        return
      }

      if (!this.new_user_name) {
        this.toast_ng("ハンドルネームを入力してください")
        return
      }

      this.base.room_code_set(this.new_room_code, this.new_user_name)
      this.room_code_field_lock()

      if (this.development_p) {
      } else {
        this.$emit("close")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 鍵有効 (合言葉が入力済みのとき)
    room_code_field_lock() {
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
  +tablet
    width: 32rem
  .modal-card-body
    padding: 0.5rem 1.5rem 1rem
    li:not(:first-child)
      margin-top: 0.75rem

  .modal-card-foot
    justify-content: space-between
    .button
      font-weight: bold
      min-width: 8rem
  .field:not(:last-child)
    margin-bottom: 1.5rem
</style>
