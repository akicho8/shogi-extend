<template lang="pug">
.XconvForm.columns.is-centered
  .column.MainColumn
    b-field(label="棋譜" :type="base.body_field_type")
      b-input(type="textarea" ref="body" v-model.trim="base.body" expanded rows="8" placeholder="KIF KI2 CSA SFEN BOD の中身またはURL。KENTOや将棋DB2のSFEN風パラメータを含むURL。棋譜ファイルへのURLをコンテンツに含むサイトのURL。戦法名・囲い名などを入力してください")

    b-field(label="SLEEP" v-if="development_p")
      b-input(type="number" v-model="base.sleep" expanded)

    b-field(label="例外メッセージ" v-if="development_p")
      b-input(type="text" v-model="base.raise_message" expanded)

    b-field(label="表示秒数/1枚")
      b-slider(:indicator="true" :tooltip="false" v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1")

    b-field(label="表示秒数/1枚")
      b-numberinput(v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1" exponential)

    SimpleRadioButtons(:base="base" :model="LoopInfo" var_name="loop_key")
    SimpleRadioButtons(:base="base" :model="AnimationFormatInfo" var_name="to_format")

    template(v-if="false")
      b-field(:label="LoopInfo.field_label" :message="LoopInfo.fetch(base.loop_key).message || LoopInfo.field_message")
        template(v-for="e in LoopInfo.values")
          b-radio-button(@input="sound_play('click')" v-model="base.loop_key" :native-value="e.key" :type="e.type")
            | {{e.name}}

    b-field
      .control
        .buttons
          b-button.has-text-weight-bold(@click="base.submit_handle" type="is-primary") 変換
</template>

<script>
import { support_child } from "./support_child.js"
import { LoopInfo } from "../models/loop_info.js"
import { AnimationFormatInfo } from "../models/animation_format_info.js"

export default {
  name: "XconvForm",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
  computed: {
    LoopInfo()            { return LoopInfo            },
    AnimationFormatInfo() { return AnimationFormatInfo },
  },
}
</script>

<style lang="sass">
.XconvForm
  .column > .field:not(:first-child)
    margin-top: 2rem
</style>
