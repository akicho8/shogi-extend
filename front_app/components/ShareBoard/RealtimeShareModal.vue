<template lang="pug">
.modal-card.RealtimeShareModal(style="width:auto")
  header.modal-card-head
    p.modal-card-title
      | リアルタイム共有
      //- span.mx-1.has-text-danger(v-if="base.$ac_room")
      //-   | (共有中)
  section.modal-card-body
    .content
      ul
        li 同じ合言葉を設定した人とリアルタイムに盤を共有できます
        li 合言葉を設定したら同じ合言葉を相手に伝えてください
        li 合言葉はURLにも付加するのでURLを伝えてもかまいません

    b-field(label="合言葉" label-position="on-border")
      b-input(type="password" v-model="new_room_code" password-reveal)

    b-field(label="ハンドルネーム" label-position="on-border")
      b-input(v-model="new_user_name")

  footer.modal-card-foot
    b-button(@click="close_handle") キャンセル
    b-button.submit_handle(@click="submit_handle" type="is-primary") 実行
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
    }
  },
  methods: {
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

      this.base.room_code_set(this.new_room_code)
      this.base.user_name = this.new_user_name

      this.close_handle()
    },
  },
}
</script>

<style lang="sass">
.RealtimeShareModal
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
      min-width: 8rem

  .field:not(:last-child)
    margin-bottom: 1.25rem

</style>
