<template lang="pug">
.modal-card.VsInputModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | 対戦相手で絞る

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    //- b-notification.mb-4(:closable="false")
    //-   | この機能を使う場合はいったんログインしてください
    //- p vs_user_key={{vs_user_key}}
    //- p filtered_list={{filtered_list}}

    b-field
      //- b-input(v-model="vs_user_key" ref="main_input_tag" placeholder="対戦相手のウォーズIDを入力")
      //- b-taginput(
      //-   v-model="vs_user_key"
      //-   :data="filtered_list"
      //-   autocomplete
      //-   allow-new
      //-   placeholder="対戦相手のウォーズIDを入力"
      //-   open-on-focus
      //-   append-to-body
      //-   @typing="filtered_list_update"
      //- )

      b-autocomplete(
        ref="main_input_tag"
        max-height="25vh"
        v-model="vs_user_key"
        :data="complete_list"
        placeholder="ウォーズIDを入力(複数指定可)"
        append-to-body
        expanded
        )
        //- open-on-focus
        //- expanded
        //- clearable
        //- type="search"
        //- size="is-medium"
        //- @select="search_select_handle"
        //- @keydown.native.enter="search_enter_handle"
        //- ref="main_search_form"

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.send_button(@click="search_handle" type="is-primary") 実行
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "VsInputModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      vs_user_key: "",
      // filtered_list: null,
    }
  },
  created() {
    // this.filtered_list = this.base.remember_vs_input_field
  },
  mounted() {
    this.input_focus()
  },
  methods: {
    // filtered_list_update(text) {
    //   this.filtered_list = this.base.remember_vs_input_field.filter((option) => {
    //     return option.toString().toLowerCase().indexOf(text.toLowerCase()) >= 0
    //   })
    // },

    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    search_handle() {
      this.sound_play("click")
      this.$emit("close")
      this.base.vs_input_filter_run_handle(this.vs_user_key)
    },
    input_focus() {
      this.desktop_focus_to(this.$refs.main_input_tag)
    },
  },
  computed: {
    complete_list() {
      // const list = this.base.config.remember_swars_user_keys
      const list = this.base.remember_vs_input_field
      if (list) {
        // list = _.reject(list, e => e === this.base.config.current_swars_user_key)
        return list.filter((option) => {
          // if (option != this.base.config.current_swars_user_key) {
          return option.toString().toLowerCase().indexOf((this.vs_user_key || "").toLowerCase()) >= 0
          // }
        })
      }
    },
  },
}
</script>

<style lang="sass">
.dropdown-content
  max-width: 200px

.VsInputModal
  +desktop
    width: 40ch
  .modal-card-body
    padding: 1.0rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
