<template lang="pug">
.XconvForm2
  SimpleRadioButtons.main_field(:base="base" :model="base.ThemeInfo" var_name="theme_key")

  b-field.main_field(label="1手あたりの秒数")
    b-numberinput(v-model="base.delay_per_one" :min="0.1" :max="3" :step="0.1" exponential @input="sound_play('click')")

  b-field.main_field(label="最後にN手ぶん停止" :message="`${base.end_seconds}秒`")
    b-numberinput(v-model="base.end_frames" :min="0" :max="10" :step="1" exponential @input="sound_play('click')")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm2",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.XconvForm2
  // > .field:not(:first-child)
  //   margin-top: 1.5rem
</style>
