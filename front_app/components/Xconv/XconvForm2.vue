<template lang="pug">
.XconvForm2
  SimpleRadioButtons.main_field(:base="base" :model="base.ViewpointInfo" var_name="viewpoint_key")
  SimpleRadioButtons.main_field(:base="base" :model="base.ColorThemeInfo" var_name="color_theme_key")
  SimpleRadioButtons.main_field(:base="base" :model="base.Mp4CreateMethodInfo" var_name="mp4_create_method_key")
  //- SimpleRadioButtons.main_field(:base="base" :model="base.AudioThemeInfo" var_name="audio_theme_key")

  b-field.main_field.audio_theme_key_field(:label="base.AudioThemeInfo.field_label" :message="base.AudioThemeInfo.fetch(base.audio_theme_key).message || base.AudioThemeInfo.field_message")
    .control
      b-dropdown(v-model="base.audio_theme_key" @active-change="sound_play('click')")
        template(#trigger)
          b-button(:label="base.audio_theme_info.name" icon-right="menu-down")
        template(v-for="e in base.AudioThemeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            b-dropdown-item(:value="e.key")
              .media
                .media-left
                  | {{e.name}}
                  //- | {{e.real_ext}}
                .media-content
                  //- .has-text-weight-bold {{e.name}}
                  h3 {{e.title}}
                  span {{e.message}}
                  //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                  //- small {{e.message}}

  b-field.main_field(label="1手N秒")
    b-numberinput(v-model="base.one_frame_duration" :min="0" :max="3" :step="0.1" exponential @input="sound_play('click')")

  b-field.main_field(label="最後N秒停止")
    b-numberinput(v-model="base.end_duration" :min="0" :max="10" :step="1" exponential @input="sound_play('click')")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm2",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvForm2
</style>
