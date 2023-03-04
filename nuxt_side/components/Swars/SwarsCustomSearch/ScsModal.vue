<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 抽出条件
  .modal-card-body
    p {{$route.query}}
    p {{$route.params}}

    b-loading(:active="$fetchState.pending")
    ScsFormAll(v-if="!$fetchState.pending")
  .modal-card-foot
    b-button.close_click_handle.has-text-weight-normal(@click="close_click_handle" icon-left="chevron-left")
    b-button.submit_click_handle(@click="submit_click_handle" type="is-primary") 実行
</template>

<script>
import { support_parent    } from "./support_parent.js"
import { mod_chore         } from "./mod_chore.js"
import { mod_query_builder } from "./mod_query_builder.js"
import { mod_modal         } from "./mod_modal.js"
import { mod_support       } from "./mod_support.js"
import { mod_form          } from "./mod_form.js"
import { mod_storage       } from "./mod_storage.js"
import { mod_sidebar       } from "./mod_sidebar.js"

export default {
  name: "ScsModal",
  mixins: [
    support_parent,
    mod_form,
    mod_chore,
    mod_query_builder,
    mod_modal,
    mod_support,
    mod_storage,
    mod_sidebar,
  ],
  // props: {
  //   xi: { type: Object,  required: true, },
  // },
  provide() {
    return {
      TheApp: this,
    }
  },
  data() {
    return {
      xi: null,
    }
  },
  fetchOnServer: false,
  fetch() {
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    this.$route.query.user_key = this.$route.params.key

    // {"key"=>"YamadaTaro", "tab_index"=>"0", "rule"=>"", "sample_max"=>"100", "xmode"=>""}
    return this.$axios.$get("/api/swars/custom_search_setup.json", {params: {}}).then(e => {
      this.xi = e
    })
  },

  methods: {
    close_click_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    submit_click_handle() {
      this.$emit("close")
      this.$router.push({name: "swars-users-key", params: {key: this.$route.params.key}, query: {query: this.new_query}})
    },
    search_click_handle() {
      // this.$sound.play_click()
      // this.remote_notify({subject: "カスタム検索", body: this.new_query})
      // this.$router.push({name: "swars-search", query: {query: this.new_query}})
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ScsModal
  // +modal_width(320px)
  // .modal-card-body
  //   padding: 1.5rem
</style>
