<template lang="pug">
client-only
  .KiwiBananaEditApp
    DebugBox(v-if="development_p")
      template(v-if="banana")
        p banana.user.id: {{banana.user && banana.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p owner_p: {{owner_p}}
        p editable_p: {{editable_p}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    KiwiBananaEditNavbar(:base="base")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        KiwiBananaEditForm(:base="base" v-if="!$fetchState.pending && !$fetchState.error")

    KiwiBananaEditDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import dayjs from "dayjs"

import { support_parent  } from "./support_parent.js"
import { mod_banana_delete } from "./mod_banana_delete.js"
import { mod_storage     } from "./mod_storage.js"

import { Banana       } from "../models/banana.js"

export default {
  name: "KiwiBananaEditApp",
  mixins: [
    support_parent,
    mod_banana_delete,
    mod_storage,
  ],

  data() {
    return {
      config: null,
      banana: null,
      // meta: null,
    }
  },

  async fetch() {
    if (this.nuxt_login_required()) { return }

    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    // app/controllers/api/kiwi/bananas_controller.rb
    const e = await this.$axios.$get("/api/kiwi/bananas/edit.json", {params})
    // if (e.error) {
    //   this.$nuxt.error(e.error)
    //   return
    // }
    this.config = e.config
    this.banana = new Banana(this, e.banana)
    // this.meta = e.meta

    // 前回保存したときの値を初期値にする
    if (this.banana.new_record_p) {
      // if (!this.banana.sequence_key) {
      //   this.banana.sequence_key = this.default_sequence_key
      // }
      if (!this.banana.folder_key) {
        this.banana.folder_key = this.default_folder_key
      }
    }

    if (this.banana.new_record_p) {
      if (this.banana.lemon.recipe_info.thumbnail_p) {
        this.toast_ok("サムネイルにする位置とかを決めてください")
      }
    }
  },

  methods: {
    banana_save_handle() {
      this.sfx_click()

      if (!this.editable_p) {
        this.toast_ng("所有者でないため更新できません")
        return
      }

      if (this.$GX.blank_p(this.banana.title)) {
        this.toast_warn("なんかしらのタイトルを捻り出そう")
        return
      }

      // https://day.js.org/docs/en/durations/diffing
      // const new_record_p = this.banana.new_record_p
      // const before_save_button_name = this.save_button_name
      const loading = this.$buefy.loading.open()
      return this.$axios.$post("/api/kiwi/bananas/save.json", {banana: this.banana.post_params}).then(e => {
        if (e.form_error_message) {
          this.toast_warn(e.form_error_message)
        }
        if (e.banana) {
          this.banana = new Banana(this, e.banana)

          this.sfx_stop_all()
          // this.toast_ok(`${before_save_button_name}しました`)
          this.toast_ok(e.message)

          // 新規の初期値にするため保存しておく
          if (e.new_record) {
            // this.default_sequence_key = this.banana.sequence_key
            this.default_folder_key = this.banana.folder_key
          }

          // this.$router.push({name: "video-studio", query: {scope: this.banana.folder_key}})
          this.$router.push({name: "video-studio"})
        }
      }).finally(() => {
        loading.close()
      })
    },
  },

  computed: {
    base()                { return this                                     },
    save_button_name()    { return this.banana.new_record_p ? "登録" : "更新" },
    // SequenceInfo()        { return SequenceInfo },

    //////////////////////////////////////////////////////////////////////////////// 編集権限
    editable_p() { return this.owner_p                               },
    disabled_p() { return !this.editable_p                           },

    owner_p() {
      if (this.banana && this.g_current_user) {
        return this.g_current_user.id === this.banana.user.id
      }
    },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaEditApp
  .MainSection.section
    +mobile
      padding: 0.5rem
    +tablet
      padding: 1.0rem

.STAGE-development
  .KiwiBananaEditApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)
    .footer
      border: 1px dashed change_color($success, $alpha: 0.5)
</style>
