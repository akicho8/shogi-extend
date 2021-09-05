<template lang="pug">
.XmovieForm2
  XmovieForm2ColorTheme(:base="base")
  XmovieForm2AudioTheme(:base="base")

  SimpleRadioButtons.one_block(:base="base" :model="base.ViewpointInfo" var_name="viewpoint_key")
  //- SimpleRadioButtons.one_block(:base="base" :model="base.ColorThemeInfo" var_name="color_theme_key" v-if="development_p")
  //- SimpleRadioButtons.one_block(:base="base" :model="base.AudioThemeInfo" var_name="audio_theme_key")

  b-field.one_block(label="1手N秒")
    b-numberinput(v-model="base.one_frame_duration_sec" :min="one_frame_duration_sec_step" :max="3" :step="one_frame_duration_sec_step" exponential @input="sound_play('click')")

  b-field.one_block(label="最後N秒停止")
    b-numberinput(v-model="base.end_duration_sec" :min="0" :max="10" :step="1" exponential @input="sound_play('click')")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieForm2",
  mixins: [support_child],
  computed: {
    one_frame_duration_sec_step() {
      if (this.base.one_frame_duration_sec <= 0.1) {
        return 0.01
      } else {
        return 0.1
      }
    },
  },

}
</script>

<style lang="sass">
.XmovieForm2
</style>
