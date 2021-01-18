<template lang="pug">
.WbookApp(:class="mode")
  WbookBuilderApp(:base="base" ref="builder")
  DebugPrint(:grep="/./")
</template>

<script>
import { support } from "./support.js"

import { config } from "./config.js"

export default {
  name: "WbookApp",
  mixins: [
    support,
    config,
  ],
  props: {
    info: { required: true },
  },
  data() {
    return {
      mode: null,
      sub_mode: null,

      // 問題編集
      edit_question_id: null, // IDを入れて builder_handle を叩けば、そのIDの編集画面に飛ぶ

      // デバッグ
      debug_summary_p: false, // ちょっとした表示
      debug_force_edit_p: false, // 他人の問題を編集できる
      debug_read_p:    false, // 表示系(安全)
      debug_write_p:   false, // 更新系(危険)
    }
  },

  async created() {
    if (this.development_p) {
      this.debug_summary_p    = true
      this.debug_force_edit_p = true
      this.debug_read_p       = true
      this.debug_write_p      = true
    }

    await this.api_get("resource_fetch", {}, e => {
      this.app_setup()
    })
  },

  methods: {
    app_setup() {
    },

    reload_if_outdated() {
      return this.silent_api_get("revision_fetch", {}, e => {
        if (this.base.config.revision === e.revision) {
          this.debug_alert(`revision: ${this.base.config.revision} OK`)
        } else {
          this.ok_notice("新しいプログラムがあるので更新します", {onend: () => location.reload(true)})
        }
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    lobby_setup_without_cable() {
      this.mode = "lobby"
      this.room = null          // 対戦中ではないことを判定するため消しておく
      this.reload_if_outdated()
    },

    lobby_setup() {
    },

    ov_redirect_onece() {
      if (this.redirect_counter >= 1) {
        return
      }

      let id = null

      id = this.$route.query.question_id
      if (id) {
        this.ov_question_info_set(id)
      }

      this.redirect_counter += 1
    },

    // 問題一覧「+」
    async builder_handle() {
      if (this.mode === "builder") {
      } else {
        if (this.sns_login_required()) { return }
        if (this.handle_name_required()) { return }
        this.mode = "builder"
      }
    },

  },

  computed: {
    base() { return this },
  },
}
</script>

<style lang="sass">
@import "support.sass"
@import "application.sass"
.WbookApp
</style>
