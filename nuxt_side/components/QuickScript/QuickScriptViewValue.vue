<template lang="pug">
.QuickScriptViewValue(:class="value_type_guess")
  template(v-if="false")

  //- { _component: "xxx", ... }
  template(v-else-if="value_type_guess === 'value_type_is_component'")
    component(:is="value['_component']" :value="value")

  // -------------------------------------------------------------------------------- ちゃんとしたハッシュ形式はコンポーネント指定できる

  //- { _v_text: "<b>bold</b>" }
  template(v-else-if="value_type_guess === 'value_type_is_v_text'")
    component(v-text="value['_v_text']" :is="value['is'] ?? 'div'" :class="value['class']")

  //- { _v_html: "<b>bold</b>" }
  template(v-else-if="value_type_guess === 'value_type_is_v_html'")
    component(v-html="value['_v_html']" :is="value['is'] ?? 'div'" :class="value['class']")

  //- { _pre: "..." }
  template(v-else-if="value_type_guess === 'value_type_is_pre'")
    component(v-text="value['_pre']" :is="value['is'] ?? 'pre'" :class="value['class']")

  //- { _autolink: "..." }
  template(v-else-if="value_type_guess === 'value_type_is_autolink'")
    component(v-html="$gs.auto_link(value['_autolink'])" :is="value['is'] ?? 'div'" :class="value['class']")

  // --------------------------------------------------------------------------------

  //- //- [ {...}, {...}, ... ]
  template(v-else-if="value_type_guess === 'value_type_is_hash_array'")
    QuickScriptViewValueAsTable(:value="{rows: value}")

  //- ["foo", "bar"]
  template(v-else-if="value_type_guess === 'value_type_is_text_array'")
    template(v-for="value in value")
      QuickScriptViewValue(:value="value")

  //- { _nuxt_link: {...} }
  template(v-else-if="value_type_guess === 'value_type_is_nuxt_link'")
    nuxt-link(:to="value['_nuxt_link'].to") {{value['_nuxt_link'].name}}

  //- { _link_to: {...} }
  template(v-else-if="value_type_guess === 'value_type_is_link_to'")
    a(:href="value['_link_to'].url" target="_blank") {{value['_link_to'].name}}

  //- "<b>foo</b>"
  template(v-else-if="value_type_guess === 'value_type_is_html'")
    div(v-html="value")

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
  name: "QuickScriptViewValue",
  inject: ["TheQS"],
  props: ["value"],
  computed: {
    value_type_guess() { return this.TheQS.value_type_guess(this.value) },
  },
}
</script>

<style lang="sass">
.QuickScriptViewValue
  // @extend %is_line_break_on
  pre
    white-space: pre-wrap
    word-break: break-all
</style>
