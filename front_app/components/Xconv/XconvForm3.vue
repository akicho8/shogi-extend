<template lang="pug">
.XconvForm3
  //- https://buefy.org/documentation/field#combining-addons-and-groups

  b-field.main_field(grouped v-if="$config.STAGE !== 'production'")
    b-field(label="プリセット" :message="[base.animation_size_info.message]")
      b-select(v-model="base.animation_size_key" @input="base.animation_size_key_input_handle" @click.native="sound_play('click')")
        option(v-for="e in base.AnimationSizeInfo.values" :value="e.key" v-text="e.option_name")
    b-field.video_width_height(label="サイズ" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.animation_size_info.key === 'is_custom'")
      b-input(required type="number" v-model.number="base.i_width"  :min="0" :max="development_p ? 3200 : 1600" :step="1" expanded placeholder="width")
      b-input(required type="number" v-model.number="base.i_height" :min="0" :max="development_p ? 3200 : 1200" :step="1" expanded placeholder="height")

  b-field.main_field(grouped v-if="$config.STAGE !== 'production'")
    b-field.animation_size_field(label="プリセット" :message="[base.animation_size_info.message]")
      b-dropdown.control(v-model="base.animation_size_key" @active-change="e => e && sound_play('click')" @input="base.animation_size_key_input_handle")
        template(#trigger)
          b-button(:label="base.animation_size_info.option_name" icon-right="menu-down")
        template(v-for="e in base.AnimationSizeInfo.values")
          b-dropdown-item(:value="e.key")
            .media
              .media-left
                | {{e.option_name}}
              .media-content
                //- h3 {{e.name}}
                span {{e.message}}
                //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                //- small {{e.message}}

    b-field.video_width_height(label="サイズ" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.animation_size_info.key === 'is_custom'")
      b-input(required type="number" v-model.number="base.i_width"  :min="0" :max="development_p ? 3200 : 1600" :step="1" placeholder="width")
      b-input(required type="number" v-model.number="base.i_height" :min="0" :max="development_p ? 3200 : 1200" :step="1" placeholder="height")

  //////////////////////////////////////////////////////////////////////////////// 縦
  //- b-field.main_field
  //-   b-field(label="プリセット" :message="[base.animation_size_info.message]" v-if="false")
  //-     b-select(v-model="base.animation_size_key" @input="base.animation_size_key_input_handle")
  //-       option(v-for="e in base.AnimationSizeInfo.values" :value="e.key" v-text="e.option_name")

  b-field.main_field.animation_size_field(label="プリセット" :message="[base.animation_size_info.message]")
    .control
      // @active-change="sound_play('click')"
      b-dropdown(v-model="base.animation_size_key" @active-change="e => e && sound_play('click')" @input="base.animation_size_key_input_handle")
        template(#trigger)
          b-button(:label="base.animation_size_info.option_name" icon-right="menu-down")
        template(v-for="e in base.AnimationSizeInfo.values")
          b-dropdown-item(:value="e.key")
            .media
              .media-left
                | {{e.option_name}}
              .media-content
                //- h3 {{e.name}}
                span {{e.message}}
                //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                //- small {{e.message}}

  b-field.main_field.video_width_height(label="サイズ" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.animation_size_info.key === 'is_custom'")
    b-input(required type="number" v-model.number="base.i_width"  :min="0" :max="development_p ? 3200 : 1600" :step="1" expanded placeholder="width" )
    b-input(required type="number" v-model.number="base.i_height" :min="0" :max="development_p ? 3200 : 1200" :step="1" expanded placeholder="height")

  //- b-field.main_field(grouped)
  //-   //- b-field(label="" expanded :message="[base.i_size_aspect_ratio_human]" )
  //-   b-field(label="プリセット" :message="[base.animation_size_info.message]")
  //-     b-select(v-model="base.animation_size_key" @input="base.animation_size_key_input_handle")
  //-       option(v-for="e in base.AnimationSizeInfo.values" :value="e.key" v-text="e.option_name")
  //-
  //-   b-field(label="サイズ" :type="{'is-danger': base.i_size_danger_p}")
  //-     b-input(required type="number" v-model.number="base.i_width"  :min="0" :max="development_p ? 3200 : 1600" :step="1" exponential expanded placeholder="width")
  //-     b-input(required type="number" v-model.number="base.i_height" :min="0" :max="development_p ? 3200 : 1200" :step="1" exponential expanded placeholder="height")
  //-     p.control(v-if="development_p && false")
  //-       span.button.is-static
  //-         | {{base.i_size_aspect_ratio_human}}

  //- https://buefy.org/documentation/field#combining-addons-and-groups
  b-field.main_field(v-if="false" :label="base.XoutFormatInfo.field_label" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
    b-select(type="number" v-model="base.xout_format_key" @input="sound_play('click')")
      option(v-for="e in base.XoutFormatInfo.values" :value="e.key" v-text="e.name")

  b-field.main_field.xout_format_key_field(label="出力形式" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
    .control
      b-dropdown(v-model="base.xout_format_key" @active-change="sound_play('click')")
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
  b-field.main_field(label="MP4のFPS(実験的設定)" message="1手1秒なら1FPSで良い気もするけど30FPS以上にしといた方が安全かもしれない")
    b-input(v-model="base.video_fps" required)
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm3",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvForm3
  // > .field:not(:first-child)
  //   margin-top: 1.5rem
  .xout_format_key_field
    .media-left
      min-width: 4ch
  .animation_size_field
    .media-left
      min-width: 4rem
</style>
