<template lang="pug">
.KiwiLemonNewFormDebug
  SimpleRadioButtons.one_block(:base="base" :model="base.MediaFactoryInfo" var_name="media_factory_key")

  b-field.one_block(label="負荷" v-if="development_p")
    b-input(type="number" v-model.number="base.sleep" expanded)

  b-field.one_block(label="例外" v-if="development_p")
    b-input(type="text" v-model="base.raise_message" expanded)
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewFormDebug",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewFormDebug
</style>
