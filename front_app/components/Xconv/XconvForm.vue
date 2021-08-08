<template lang="pug">
.XconvForm.columns.is-centered
  .column.MainColumn
    b-field(label="棋譜" :type="base.body_field_type")
      b-input(type="textarea" ref="body" v-model.trim="base.body" expanded rows="8" placeholder="KIF KI2 CSA SFEN BOD の中身またはURL。KENTOや将棋DB2のSFEN風パラメータを含むURL。棋譜ファイルへのURLをコンテンツに含むサイトのURL。戦法名・囲い名などを入力してください")

    b-field(label="SLEEP" v-if="development_p")
      b-input(type="number" v-model="base.sleep" expanded)

    b-field(label="例外メッセージ" v-if="development_p")
      b-input(type="text" v-model="base.raise_message" expanded)

    b-field(label="表示秒数/1枚" v-if="development_p")
      b-slider(:indicator="true" :tooltip="false" v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1")

    b-field(label="表示秒数/1枚")
      b-numberinput(v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1" exponential)

    b-field(label="終了図停止枚数" message="ループする場合に最後の局面を少し止めて終局した風にする")
      b-numberinput(v-model="base.end_frames" :min="0" :max="15" :step="1" exponential)

    //- https://buefy.org/documentation/field#combining-addons-and-groups
    b-field(grouped)
      b-field(label="サイズ" expanded :message="[base.animation_size_info.message, base.i_size_ratio_human]" )
        b-field(:type="{'is-danger': base.i_size_danger_p}")
          b-select(type="number" v-model="base.animation_size_key" @input="base.animation_size_key_input_handle")
            option(v-for="e in base.AnimationSizeInfo.values" :value="e.key" v-text="e.name")
          b-input(required type="number" v-model="base.i_width"  :min="0" :max="development_p ? 3200 : 1600" :step="1" exponential expanded placeholder="width")
          b-input(required type="number" v-model="base.i_height" :min="0" :max="development_p ? 3200 : 1200" :step="1" exponential expanded placeholder="height")
          p.control(v-if="development_p && false")
            span.button.is-static
              | {{base.i_size_ratio_human}}

    SimpleRadioButtons(:base="base" :model="base.ViewpointInfo" var_name="viewpoint_key")
    //- SimpleRadioButtons(:base="base" :model="base.AnimationSizeInfo" var_name="animation_size_key")
    SimpleRadioButtons(:base="base" :model="base.LoopInfo" var_name="loop_key")
    SimpleRadioButtons(:base="base" :model="base.XoutFormatInfo" var_name="xout_format_key")

    //- SimpleRadioButtons(:base="base" :model="base.XoutFormatInfo" var_name="xout_format_key")

    b-field(:label="base.XoutFormatInfo.field_label" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
      template(#label)
        | Label with custom
        span(class="has-text-primary is-italic") style
      template(v-for="e in base.XoutFormatInfo.values")
        template(v-if="blank_p(e.development_only) || development_p")
          b-radio-button(@input="sound_play('click')" v-model="base.xout_format_key" :native-value="e.key" :type="e.type")
            | {{e.name}}

    //- https://buefy.org/documentation/field#combining-addons-and-groups
    b-field(:label="base.XoutFormatInfo.field_label" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
      b-select(type="number" v-model="base.xout_format_key" @input="sound_play('click')")
        option(v-for="e in base.XoutFormatInfo.values" :value="e.key" v-text="e.name")

    template(v-if="false")
      b-field(:label="base.LoopInfo.field_label" :message="base.LoopInfo.fetch(base.loop_key).message || base.LoopInfo.field_message")
        template(v-for="e in base.LoopInfo.values")
          b-radio-button(@input="sound_play('click')" v-model="base.loop_key" :native-value="e.key" :type="e.type")
            | {{e.name}}

    b-field
      .control
        .buttons
          b-button.has-text-weight-bold(@click="base.submit_handle" type="is-primary") 変換
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.XconvForm
  .column > .field:not(:first-child)
    margin-top: 2rem
</style>
