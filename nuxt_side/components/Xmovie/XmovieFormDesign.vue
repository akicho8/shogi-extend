<template lang="pug">
.XmovieFormDesign
  XmovieFormDesignColorTheme(:base="base")
  XmovieFormDesignAudioTheme(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieFormDesign",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieFormDesign
</style>
