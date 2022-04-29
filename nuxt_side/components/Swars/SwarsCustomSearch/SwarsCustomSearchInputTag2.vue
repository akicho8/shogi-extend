<template lang="pug">
b-field.field_block.SwarsCustomSearchInputTag2
  template(#label)
    | 対戦相手({{base.vs_user_keys.length}})
    span.mx-2(class="has-text-grey has-text-weight-normal is-italic is-size-7")
      | 入力後にEnterで確定してください
  b-taginput(
    @blur.native="fobar"
    v-model="base.vs_user_keys"
    :data="filtered_tags"
    autocomplete
    open-on-focus
    allow-new
    placeholder=""
    @typing="filtered_tags_rebuild"
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
import _ from "lodash"
import { support_child } from "./support_child.js"

const VS_USERS_ARRAY_SIZE_MAX = 20

export default {
  name: "SwarsCustomSearchInputTag2",
  mixins: [
    support_child,
  ],
  props: {
  },
  data() {
    return {
      filtered_tags: null, // 干渉しないようにコンポーネントローカルにすること
    }
  },
  created() {
    this.filtered_tags_rebuild("") // open-on-focus で open するために最初に作っておく
  },
  methods: {
    fobar() {
      alert(1)
    },
    filtered_tags_rebuild(text) {
      text = this.normalize_for_autocomplete(text)
      this.filtered_tags = this.base.remember_vs_user_keys.filter(e => this.normalize_for_autocomplete(e).indexOf(text) >= 0)
    },
    // op_click_handle(e) {
    //   if (this.current_op !== e.key) {
    //     this.current_op = e.key
    //     this.sound_play_click()
    //     this.talk(e.yomiage)
    //   }
    // },
    add_handle(tag) {
      this.remember_update(tag)
      this.sound_play_toggle(true)
      this.talk(tag)
    },
    remove_handle(tag) {
      this.sound_play_toggle(false)
    },

    remember_update(str) {
      let av = this.str_to_tags(str)
      if (this.present_p(av)) {
        av = [...av, ...this.base.remember_vs_user_keys]
        av = _.uniq(av)
        av = _.take(av, VS_USERS_ARRAY_SIZE_MAX)
        this.base.remember_vs_user_keys = av
      }
    },

  },
  computed: {
    // current_op: {
    //   set(v) { this.base.$data[this.op_var] = v    },
    //   get()  { return this.base.$data[this.op_var] },
    // },
  },
}
</script>

<style lang="sass">
.SwarsCustomSearchInputTag2
  // .logical_block
  //   a:not(:first-child)
  //     margin-left: 0.25em
</style>
