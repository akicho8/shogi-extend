<template lang="pug">
.KiwiLemonNewFormDesign
  KiwiLemonNewFormDesignColorTheme(:base="base")
  KiwiLemonNewFormDesignAudioTheme(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewFormDesign",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewFormDesign
</style>
