<template lang="pug">
.modal-card.RealtimeShareModal(style="width:auto")
  header.modal-card-head
    p.modal-card-title
      | 合言葉とハンドルネームの設定
      //- span.mx-1.has-text-danger(v-if="base.$ac_room")
      //-   | (共有中)
  section.modal-card-body
    .content.is-size-7
      ul
        li 同じ合言葉を設定した人とリアルタイムに盤を共有します
        li 合言葉を設定したら同じ合言葉をこっそり相手に伝えてください
        li メニューにある「合言葉設定済みURL」を伝えてもかまいません
        li 共有のタイミングは<b>指したときだけ</b>です ← 重要
        li 間違えて指したときなどは(合意を得た上で)局面を戻して指し直せばよいです
        li 指し手のログの行をタップするとそのときの局面に戻ります

    template(v-if="input_show_p")
      b-field(label="合言葉" label-position="on-border" key="input_show_p_true")
        b-input(v-model="new_room_code")
    template(v-else)
      b-field(label="合言葉 (設定済み)" custom-class="is-small" key="input_show_p_false")
        .control
          b-button(@click="room_code_show_toggle_handle" icon-left="lock" type="is-danger") 変更

    b-field(label="ハンドルネーム" label-position="on-border")
      b-input(v-model="new_user_name")

  footer.modal-card-foot
    b-button(@click="close_handle") キャンセル
    b-button.submit_handle(@click="submit_handle" type="is-primary") 確定
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "RealtimeShareModal",
  mixins: [support_child],
  props: {
  },
  data() {
    return {
      new_room_code: this.base.room_code,
      new_user_name: this.base.user_name,
      input_show_p: !this.base.room_code,
    }
  },
  methods: {
    room_code_show_toggle_handle() {
      this.sound_play("click")
      this.input_show_p = true
    },
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    submit_handle() {
      this.new_room_code = _.trim(this.new_room_code)
      this.new_user_name = _.trim(this.new_user_name)

      if (this.new_room_code) {
        if (!this.new_user_name) {
          this.toast_ng("ハンドルネームを入力してください")
          return
        }
      }

      this.base.room_code_set(this.new_room_code, this.new_user_name)

      this.close_handle()
    },
  },
}
</script>

<style lang="sass">
.RealtimeShareModal
  .modal-card-body
    padding-top: 0.5rem
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
      min-width: 8rem

  .field:not(:last-child)
    margin-bottom: 1.5rem

</style>
