<template lang="pug">
.XconvForm3
  //- https://buefy.org/documentation/field#combining-addons-and-groups
  b-field.main_field(grouped)
    b-field(label="サイズ" expanded :message="[base.animation_size_info.message, base.i_size_aspect_ratio_human]" )
      b-field(:type="{'is-danger': base.i_size_danger_p}")
        b-select(type="number" v-model="base.animation_size_key" @input="base.animation_size_key_input_handle")
          option(v-for="e in base.AnimationSizeInfo.values" :value="e.key" v-text="e.option_name")
        b-input(required type="number" v-model="base.i_width"  :min="0" :max="development_p ? 3200 : 1600" :step="1" exponential expanded placeholder="width")
        b-input(required type="number" v-model="base.i_height" :min="0" :max="development_p ? 3200 : 1200" :step="1" exponential expanded placeholder="height")
        p.control(v-if="development_p && false")
          span.button.is-static
            | {{base.i_size_aspect_ratio_human}}

  //- https://buefy.org/documentation/field#combining-addons-and-groups
  b-field.main_field(v-if="false" :label="base.XoutFormatInfo.field_label" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
    b-select(type="number" v-model="base.xout_format_key" @input="sound_play('click')")
      option(v-for="e in base.XoutFormatInfo.values" :value="e.key" v-text="e.name")

  b-field.main_field(label="出力形式" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
    b-dropdown.xout_format_key_dropdown.control(v-model="base.xout_format_key" @active-change="sound_play('click')")
      template(#trigger)
        b-button(:label="base.xout_format_info.name" icon-right="menu-down")
      template(v-for="e in base.XoutFormatInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          b-dropdown-item(:value="e.key")
            .media
              .media-left
                | {{e.name}}
                //- | {{e.real_ext}}
              .media-content
                //- .has-text-weight-bold {{e.name}}
                //- h3 {{e.name}}
                span {{e.message}}
                //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                //- small {{e.message}}

  b-field.main_field(label="表示秒数/1枚" v-if="development_p && false")
    b-slider(:indicator="true" :tooltip="false" v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1")

  //- SimpleRadioButtons(:base="base" :model="base.AnimationSizeInfo" var_name="animation_size_key")
  // SimpleRadioButtons(:base="base" :model="base.XoutFormatInfo" var_name="xout_format_key")

  //- b-collapse(:open="false" position="is-bottom")
  //-   template(#trigger="props")
  //-     a
  //-       b-icon(:icon="!props.open ? 'menu-down' : 'menu-up'")
  //-       template(v-if="!props.open")
  //-         | すべてのフォームを表示する
  //-       template(v-else)
  //-         | 隠す

  SimpleRadioButtons.main_field(:base="base" :model="base.LoopInfo" var_name="loop_key")

  //- b-field.main_field(label="FPS")
  //-   b-numberinput(v-model="base.video_fps" :min="30" :max="60" :step="1" exponential @input="sound_play('click')")
  //- b-field.main_field(label="FPS")
  //-   b-numberinput(v-model="base.video_fps" :min="1" :max="60" :step="0.01" exponential)
  b-field.main_field(label="FPS")
    b-input(v-model="base.video_fps" required)

  .box(v-if="development_p")
    b-field.main_field(label="*負荷")
      b-input(type="number" v-model="base.sleep" expanded)

    b-field.main_field(label="*例外")
      b-input(type="text" v-model="base.raise_message" expanded)

  //- SimpleRadioButtons(:base="base" :model="base.XoutFormatInfo" var_name="xout_format_key")
  b-field.main_field(v-if="false" :label="base.XoutFormatInfo.field_label" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
    template(#label)
      | Label with custom
      span(class="has-text-primary is-italic") style
    template(v-for="e in base.XoutFormatInfo.values")
      template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
        b-radio-button(@input="sound_play('click')" v-model="base.xout_format_key" :native-value="e.key" :type="e.type")
          | {{e.name}}

  template(v-if="false")
    b-field.main_field(:label="base.LoopInfo.field_label" :message="base.LoopInfo.fetch(base.loop_key).message || base.LoopInfo.field_message")
      template(v-for="e in base.LoopInfo.values")
        b-radio-button(@input="sound_play('click')" v-model="base.loop_key" :native-value="e.key" :type="e.type")
          | {{e.name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm3",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.XconvForm3
  // > .field:not(:first-child)
  //   margin-top: 1.5rem
  .xout_format_key_dropdown
    .dropdown-item
      &:not(.is-active)         // 選択してない項目だけ種類を青くする
        .media-left
          color: $primary
      .media-left
        min-width: 4ch
        font-weight: bold
</style>
