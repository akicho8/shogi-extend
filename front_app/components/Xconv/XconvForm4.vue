<template lang="pug">
.XconvForm4
  b-field.main_field(label="負荷" v-if="development_p")
    b-input(type="number" v-model.number="base.sleep" expanded)

  b-field.main_field(label="例外" v-if="development_p")
    b-input(type="text" v-model="base.raise_message" expanded)
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm4",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvForm4
</style>
