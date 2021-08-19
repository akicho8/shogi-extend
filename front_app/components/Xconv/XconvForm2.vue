<template lang="pug">
.XconvForm2
  SimpleRadioButtons.main_field(:base="base" :model="base.ViewpointInfo" var_name="viewpoint_key")
  SimpleRadioButtons.main_field(:base="base" :model="base.ThemeInfo" var_name="color_theme_key")

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
