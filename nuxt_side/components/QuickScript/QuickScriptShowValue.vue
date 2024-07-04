<template lang="pug">
.QuickScriptShowValue
  template(v-if="false")

  //- { _component: "xxx", ... }
  template(v-else-if="value_type_guess === 'value_type_is_component'")
    component(:is="value['_component']" :value="value")

  //- //- [ {...}, {...}, ... ]
  template(v-else-if="value_type_guess === 'value_type_is_hash_array'")
    QuickScriptShowValueAsTable(:value="{rows: value}")

  //- ["foo", "bar"]
  template(v-else-if="value_type_guess === 'value_type_is_text_array'")
    template(v-for="value in value")
      QuickScriptShowValue(:value="value")

  //- { _nuxt_link: {...} }
  template(v-else-if="value_type_guess === 'value_type_is_nuxt_link'")
    nuxt-link(:to="value['_nuxt_link'].to") {{value['_nuxt_link'].name}}

  //- { _link_to: {...} }
  template(v-else-if="value_type_guess === 'value_type_is_link_to'")
    a(:href="value['_link_to'].url" target="_blank") {{value['_link_to'].name}}

  //- "<b>foo</b>"
  template(v-else-if="value_type_guess === 'value_type_is_html'")
    div(v-html="value")

  //- "エスケープされたくない文字列"
  template(v-else-if="value_type_guess === 'value_type_is_v_text'")
    | {{value["_v_text"]}}

  //- { _pre: "..." }
  template(v-else-if="value_type_guess === 'value_type_is_pre'")
    pre {{value["_pre"]}}

  //- { _autolink: "..." }
  template(v-else-if="value_type_guess === 'value_type_is_autolink'")
    div(v-html="$gs.auto_link(value['_autolink'])")

  //- 謎のハッシュ (auto_link するとエラーになるため)
  template(v-else-if="value_type_guess === 'value_type_is_any_hash'")
    pre {{value}}

  //- 普通のテキスト
  template(v-else-if="value_type_guess === 'value_type_is_text'")
    | {{value}}

  //- 数字や nil
  template(v-else)
    | {{value}}
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

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
  pre
    white-space: pre-wrap
    word-break: break-all
</style>
