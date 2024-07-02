<template lang="pug">
.QuickScriptShowValue
  template(v-if="false")
  //- ["foo", "bar"]
  template(v-else-if="value_type_guess === 'value_type_is_string_array'")
    template(v-for="value in value")
      QuickScriptShowValue(:value="value")
  //- { _nuxt_link: {...} }
  template(v-else-if="value_type_guess === 'value_type_is_nuxt_link'")
    nuxt-link(:to="value['_nuxt_link'].to") {{value['_nuxt_link'].name}}
  //- { _link_to: {...} }
  template(v-else-if="value_type_guess === 'value_type_is_link_to'")
    a(:href="value['_link_to'].url" target="_blank") {{value['_link_to'].name}}
  //- "<b>foo</b>"
  template(v-else-if="value_type_guess === 'value_type_is_beginning_html_tag'")
    div(v-html="value")
  //- "エスケープされたくない文字列"
  template(v-else-if="value_type_guess === 'value_type_is_v_text'")
    | {{value["_v_text"]}}
  //- 謎のハッシュ (auto_link するとエラーになるため)
  template(v-else-if="value_type_guess === 'value_type_is_any_hash'")
    pre {{value}}
  //- "エスケープされてもよい文字列 https://example.com/"
  template(v-else)
    div(v-html="$gs.auto_link(value)")
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import Vue from 'vue'

export default {
  name: "QuickScriptShowValue",
  inject: ["TheQS"],
  props: ["value"],
  computed: {
    value_type_guess() { return this.TheQS.value_type_guess(this.value) },
  },
}
</script>

<style lang="sass">
.QuickScriptShowValue
  __css_keep__: 0
</style>
