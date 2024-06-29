<template lang="pug">
.QuickScriptIndex
  b-loading(:active="$fetchState.pending")
  template(v-if="params")
    .title(v-if="params.meta.title")
      | {{params.meta.title}}
    .section
      template(v-for="row in params.rows")
        p {{row}}
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import Vue from 'vue'

export default {
  name: "QuickScriptIndex",
  mixins: [],
  provide() {
    return {
      TheQS: this,
    }
  },
  data() {
    return {
      params: null,
    }
  },
  // watch: {
  //   "$route.query": "$fetch",
  // },
  fetchOnServer: true,
  fetch() {
    return this.$axios.$get(`/api/quick_scripts`, {params: this.$route.query}).then(params => {
      this.params = params
    })
  },
  computed: {
    meta() {
      if (this.params) {
        return this.params.meta
      }
    },
  },
}
</script>

<style lang="sass">
.QuickScriptIndex
  __css_keep__: 0
</style>
