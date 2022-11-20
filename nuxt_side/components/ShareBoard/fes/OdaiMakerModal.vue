<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | お題メーカー
      span.mx-1.has-text-grey.has-text-weight-normal(v-if="TheSb.debug_mode_p")
        | (ID:{{TheSb.master_odai.unique_code}})
  .modal-card-body
    b-field(label="お題" custom-class="is-small")
      b-input(v-model="TheSb.master_odai.subject" placeholder="どっちがお好き？")
    b-field(label="選択肢1" custom-class="is-small")
      b-input(v-model="TheSb.master_odai.items[0]" placeholder="マヨネーズ")
    b-field(label="選択肢2" custom-class="is-small")
      b-input(v-model="TheSb.master_odai.items[1]" placeholder="ケチャップ")
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle") キャンセル
    b-button(@click="submit_handle" type="is-primary")
      | 送信する
      //- template(v-if="TheSb.odai_new_p") 送信する
      //- template(v-if="TheSb.odai_persisted_p") 再送信する
</template>

<script>
import { support_child } from "../support_child.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

const VALIDATION_ON = false

export default {
  name: "OdaiMakerModal",
  mixins: [support_child],
  inject: ["TheSb"],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    submit_handle() {
      this.$sound.play_click()
      if (VALIDATION_ON) {
        if (this.TheSb.master_odai.invalid_p) {
          this.toast_warn("ぜんぶ入力してください")
          return
        }
      }
      this.TheSb.odai_share(this.TheSb.master_odai)
      this.$emit("close")
    },
  },
  computed: {
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.OdaiMakerModal
  +modal_width(30rem)

  .modal-card-body
    padding: 20px

  .modal-card-foot
    .button
      min-width: 6rem

.STAGE-development
  .OdaiMakerModal
</style>
