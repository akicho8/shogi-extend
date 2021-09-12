<template lang="pug">
.XmovieForm2
  b-field.one_block(label="表紙")
    b-input(type="textarea" v-model.trim="base.cover_text" expanded rows="4" placeholder="御城将棋\n☗六代大橋宗銀 vs ☖伊藤印達\n1711/02/28")
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
