<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | お題メーカー
      span.mx-1.has-text-grey.has-text-weight-normal(v-if="TheSb.debug_mode_p")
        | (ID:{{TheSb.master_odai.unique_code}})
    a.odai_src_random_handle(@click="odai_src_random_handle")
      b-icon(:icon="dice.to_icon")
  .modal-card-body
    b-field(label-position="on-border")
      template(#label)
        | お題
        span.mx-1(class="has-text-grey") 例: {{example.subject}}
      b-input.odai_subject(v-model="TheSb.master_odai.subject" ref="subject_input_tag")
    b-field(grouped)
      b-field(label="選択肢1" label-position="on-border")
        b-input.odai_left(v-model="TheSb.master_odai.left_value" :placeholder="example.left_value" expanded)
      b-field(label="選択肢2" label-position="on-border")
        b-input.odai_right(v-model="TheSb.master_odai.right_value" :placeholder="example.right_value" expanded)
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle") キャンセル
    b-button(@click="submit_handle" type="is-primary")
      | 出題する
      //- template(v-if="TheSb.odai_new_p") 送信する
      //- template(v-if="TheSb.odai_persisted_p") 再送信する
</template>

<script>
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"
import { Dice } from "@/components/models/dice.js"

const VALIDATION_ON = false
import { support_child } from "../support_child.js"

export default {
  name: "OdaiMakerModal",
  mixins: [support_child],
  data() {
    return {
      dice: new Dice(),
    }
  },
  mounted() {
    this.input_focus()
  },
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
    // お題名が空のときかつデスクトップならフォーカスする
    input_focus() {
      if (this.$gs.blank_p(this.TheSb.master_odai.subject)) {
        this.desktop_focus_to(this.$refs.subject_input_tag)
      }
    },
    odai_src_random_handle() {
      this.dice.roll()
      this.TheSb.odai_src_random_handle()
    },
  },
  computed: {
    example() {
      return _.sample([
        { subject: "どっちがお好き？",                   left_value: "マヨネーズ",       right_value: "ケチャップ",      },
        // { subject: "アナタはどっち派？ドラゴンクエスト", left_value: "ガンガンいこうぜ", right_value: "いのちだいじに",  },
      ])
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.OdaiMakerModal
  +modal_width(30rem)

  .modal-card-body
    padding: 20px
    display: flex
    flex-direction: column
    gap: 0.5rem
    .field.is-grouped
      gap: 1rem
      .field
        flex-shrink: 1
        width: 100%
        margin: 0

  .modal-card-foot
    .button
      min-width: 6rem

.STAGE-development
  .OdaiMakerModal
    __css_keep__: 0
</style>
