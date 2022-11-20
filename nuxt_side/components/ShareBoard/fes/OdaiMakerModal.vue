<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title お題メーカー
  .modal-card-body
    b-field(label="お題" custom-class="is-small")
      b-input(v-model="TheSb.odai_src.subject" placeholder="どっちがお好き？" required)
    b-field(label="選択肢1" custom-class="is-small")
      b-input(v-model="TheSb.odai_src.items[0]" placeholder="マヨネーズ" required)
    b-field(label="選択肢2" custom-class="is-small")
      b-input(v-model="TheSb.odai_src.items[1]" placeholder="ケチャップ" required)
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle") キャンセル
    b-button(@click="submit_handle" type="is-primary") 送信する
</template>

<script>
import { support_child } from "../support_child.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "ClientVoteModal",
  mixins: [support_child],
  inject: ["TheSb"],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    submit_handle() {
      this.$sound.play_click()
      if (this.TheSb.odai_src.invalid_p) {
        this.toast_warn("ぜんぶ入力してください")
        return
      }
      this.TheSb.odai_share(this.TheSb.odai_src)
      this.$emit("close")
    },
  },
  computed: {
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.ClientVoteModal
  +modal_width(30rem)

  .modal-card-body
    padding: 20px

  .modal-card-foot
    .button
      min-width: 6rem

.STAGE-development
  .ClientVoteModal
</style>
