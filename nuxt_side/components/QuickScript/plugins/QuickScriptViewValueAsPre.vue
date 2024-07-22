<template lang="pug">
pre.QuickScriptViewValueAsPre
  | {{value}}
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export default {
  name: "QuickScriptViewValueAsPre",
  inject: ["QS"],
  props: ["value"],
}
</script>

<style lang="sass">
pre.QuickScriptViewValueAsPre
  __css_keep__: 0
</style>
