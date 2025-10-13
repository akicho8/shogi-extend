<template lang="pug">
.QuickScriptViewValue(:class="value_type_guess")
  template(v-if="false")

  // --------------------------------------------------------------------------------

  //- //- [ {...}, {...}, ... ]
  template(v-else-if="value_type_guess === 'value_type_is_hash_array'")
    QuickScriptViewValueAsTable(:value="{rows: value}")

  //- ["foo", "bar"]
  template(v-else-if="value_type_guess === 'value_type_is_text_array'")
    template(v-for="value in value")
      QuickScriptViewValue(:value="value")

  // -------------------------------------------------------------------------------- コンポーネント主体

  //- { _component: "xxx", _v_bind: { ... } }
  template(v-else-if="value_type_guess === 'value_type_is_component'")
    component(:is="value['_component']" v-bind="value._v_bind" :class="value['class']" :style="value['style']")

  // -------------------------------------------------------------------------------- コンポーネントショートカット(v-text / v-html などが主体)

  //- { _v_text: "<b>bold</b>" }
  template(v-else-if="value_type_guess === 'value_type_is_v_text'")
    component(:is="value['is'] ?? 'div'" v-bind="value['_v_bind']" :class="value['class']" :style="value['style']" v-text="value['_v_text']")

  //- { _v_html: "<b>bold</b>" }
  template(v-else-if="value_type_guess === 'value_type_is_v_html'")
    component(:is="value['is'] ?? 'div'" v-bind="value['_v_bind']" :class="value['class']" :style="value['style']" v-html="value['_v_html']" )

  //- { _pre: "..." }
  template(v-else-if="value_type_guess === 'value_type_is_pre'")
    component(:is="value['is'] ?? 'pre'" v-bind="value['_v_bind']" :class="value['class']" :style="value['style']" v-text="value['_pre']")

  //- { _autolink: "..." }
  template(v-else-if="value_type_guess === 'value_type_is_autolink'")
    component(:is="value['is'] ?? 'div'" v-bind="value['_v_bind']" :class="value['class']" :style="value['style']" v-html="$GX.auto_link(value['_autolink'], {email: false})")

  // --------------------------------------------------------------------------------

  //- { _nuxt_link: {...} }
  template(v-else-if="value_type_guess === 'value_type_is_nuxt_link'")
    nuxt-link(v-bind="value._v_bind" :class="value['class']" :style="value['style']" v-html="value._nuxt_link")

  //- { _link_to: {...} }
  template(v-else-if="value_type_guess === 'value_type_is_link_to'")
    a(v-bind="value._v_bind" :class="value['class']" :style="value['style']" v-html="value._link_to")

  // --------------------------------------------------------------------------------

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
import { GX } from "@/components/models/gx.js"

export default {
  name: "QuickScriptViewValue",
  inject: ["QS"],
  props: ["value"],
  computed: {
    value_type_guess() { return this.QS.value_type_guess(this.value) },
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
