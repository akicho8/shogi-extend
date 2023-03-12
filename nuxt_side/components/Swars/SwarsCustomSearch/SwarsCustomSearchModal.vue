<template lang="pug">
.ScsModalInner
  b-loading(:active="$fetchState.pending")
  .modal-card(v-if="!$fetchState.pending")
    .modal-card-head
      .modal-card-title
        | {{new_query_without_user_key || "条件なし"}}
    .modal-card-body
      SwarsCustomSearchFormAll(
        :new_query_field_show="false"
        :user_key_field_show="false"
      )
      .buttons.is-centered.mb-0.are-small(v-if="development_p")
        b-button.mb-0(@click="form_reset_handle") オプション類を外す
        b-button.mb-0(@click="all_reset_handle") 完全リセット
        b-button.mb-0(@click="parmalink_handle") パーマリンク化
    .modal-card-foot
      b-button.close_click_handle.has-text-weight-normal(@click="close_click_handle" icon-left="chevron-left")
      b-button.submit_click_handle(@click="submit_click_handle" type="is-primary") 絞り込む
</template>

<script>
import { support_parent    } from "./support_parent.js"
import { mod_chore         } from "./mod_chore.js"
import { mod_query_builder } from "./mod_query_builder.js"
import { mod_support       } from "./mod_support.js"
import { mod_form          } from "./mod_form.js"
import { mod_storage       } from "./mod_storage.js"
import { mod_sidebar       } from "./mod_sidebar.js"

export default {
  name: "SwarsCustomSearchModal",
  mixins: [
    support_parent,
    mod_form,
    mod_chore,
    mod_query_builder,
    mod_support,
    mod_storage,
    mod_sidebar,
  ],
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
    return this.$axios.$get("/api/swars/custom_search_setup", {params: {}}).then(e => this.xi = e)
  },
  methods: {
    close_click_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    submit_click_handle() {
      this.$sound.play_click()
      this.$emit("close")
      this.$router.push({
        name: "swars-users-key",
        params: {
          ...this.$route.params,
        },
        query: {
          ...this.$route.query,
          query: this.new_query_without_user_key,
        },
      })
    },
    search_click_handle() {
      alert("new_query_field_show = false としているため呼ばれない")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.SwarsCustomSearchModal
  .modal-card-body
    padding: 0 1.5rem
  .modal-card-foot
    .button
      min-width: 10rem
</style>
