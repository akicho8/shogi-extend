<template lang="pug">
pre.QuickScriptShowValueAsPre
  | {{value.body}}
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export default {
  name: "QuickScriptShowValueAsPre",
  inject: ["TheQS"],
  props: ["value"],
}
</script>

<style lang="sass">
pre.QuickScriptShowValueAsPre
  __css_keep__: 0
</style>
