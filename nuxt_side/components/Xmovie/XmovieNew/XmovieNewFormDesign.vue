<template lang="pug">
.XmovieNewFormDesign
  XmovieNewFormDesignColorTheme(:base="base")
  XmovieNewFormDesignAudioTheme(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieNewFormDesign",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieNewFormDesign
</style>
