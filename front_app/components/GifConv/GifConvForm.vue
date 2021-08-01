<template lang="pug">
.GifConvForm.columns.is-centered(v-if="component_show_p")
  .column.MainColumn
    b-field(label="棋譜" :type="base.body_field_type")
      b-input(type="textarea" ref="body" v-model.trim="base.body" expanded rows="8" placeholder="KIF KI2 CSA SFEN BOD の中身またはURL。KENTOや将棋DB2のSFEN風パラメータを含むURL。棋譜ファイルへのURLをコンテンツに含むサイトのURL。戦法名・囲い名などを入力してください")

    b-field(label="SLEEP" v-if="development_p")
      b-input(type="number" v-model="base.sleep" expanded)

    //- b-field(label="表示秒数/1枚")
    //-   b-slider(:indicator="true" :tooltip="false" v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1")

    b-field(label="表示秒数/1枚")
      b-numberinput(v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1" exponential)

    SimpleRadioButtons(:base="base" :model="LoopInfo" var_name="loop")

    template(v-if="false")
      b-field(:label="LoopInfo.field_label" :message="LoopInfo.fetch(base.loop).message || LoopInfo.field_message")
        template(v-for="e in LoopInfo.values")
          b-radio-button(@input="sound_play('click')" v-model="base.loop" :native-value="e.key" :type="e.type")
            | {{e.name}}

    b-field
      .control
        .buttons
          b-button.has-text-weight-bold(@click="base.sumit_handle" type="is-primary") 変換
</template>

<script>
import { support_child } from "./support_child.js"
import { LoopInfo } from "../models/loop_info.js"

export default {
  name: "GifConvForm",
  mixins: [support_child],
  computed: {
    LoopInfo() { return LoopInfo },

    component_show_p() {
      return this.blank_p(this.base.henkan_record)
    },
  },
}
</script>

<style lang="sass">
.GifConvForm
  .column > .field:not(:first-child)
    margin-top: 2rem
</style>
