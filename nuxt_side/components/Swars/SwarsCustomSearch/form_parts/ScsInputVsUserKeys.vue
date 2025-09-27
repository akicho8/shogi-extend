<template lang="pug">
b-field.field_block.ScsInputVsUserKeys(custom-class="is-small")
  template(#label)
    | 対戦相手({{TheApp.vs_user_keys.length}})
    span.mx-2(class="has-text-grey has-text-weight-normal is-italic is-size-7")
      | 改行で確定
  b-taginput(
    :size="TheApp.input_element_size"
    v-model="TheApp.vs_user_keys"
    :data="filtered_keys"
    autocomplete
    open-on-focus
    allow-new
    placeholder=""
    spellcheck="false"
    @typing="typing_handle"
    @add="add_handle"
    @remove="remove_handle"
    max-height="50vh"
    expanded
    attached
    :confirm-keys="[',', 'Tab', 'Enter', ' ']"
    :on-paste-separators="[',', ' ']"
    )
</template>

<script>
const VS_USERS_ARRAY_SIZE_MAX = 20

import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "ScsInputVsUserKeys",
  mixins: [
    support_child,
  ],
  data() {
    return {
      filtered_keys: null, // 干渉しないようにコンポーネントローカルにすること
    }
  },
  created() {
    this.typing_handle("") // open-on-focus で open するために最初に作っておく
  },
  methods: {
    typing_handle(text) {
      text = this.$gs.str_normalize_for_ac(text)
      this.filtered_keys = this.TheApp.remember_vs_user_keys.filter(e => {
        // 1. vs_user_keys にまだ含まれていないものかつ (すでに入力した名前を補完に出さないようにするため)
        // 2. マッチするものに絞る
        return !this.TheApp.vs_user_keys.includes(e) && this.$gs.str_normalize_for_ac(e).indexOf(text) >= 0
      })
    },
    add_handle(key) {
      this.remember_update(key)
      this.sfx_play_toggle(true)
      this.talk(key)
    },
    remove_handle(key) {
      this.sfx_play_toggle(false)
    },
    remember_update(key) {
      let av = this.$gs.str_to_tags(key)
      if (this.$gs.present_p(av)) {
        av = [...av, ...this.TheApp.remember_vs_user_keys]
        av = _.uniq(av)
        av = _.take(av, VS_USERS_ARRAY_SIZE_MAX)
        this.TheApp.remember_vs_user_keys = av
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ScsInputVsUserKeys
  __css_keep__: 0
</style>
