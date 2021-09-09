<template lang="pug">
.XmovieForm2
  SimpleRadioButtons.one_block(:base="base" :model="base.ViewpointInfo" var_name="viewpoint_key")
  XmovieForm2ColorTheme(:base="base")
  XmovieForm2AudioTheme(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieForm2",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieForm2
</style>
