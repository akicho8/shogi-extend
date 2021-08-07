<template lang="pug">
.XconvApp
  DebugBox(v-if="development_p")
    div foo:

  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(@click="reset_handle") アニメーション変換

  MainSection
    .container
      XconvForm(:base="base" ref="XconvForm" v-if="form_show_p")
      XconvPreview(:base="base")

      template(v-if="response_hash && response_hash.url")
        .columns
          .column
            .box
              b-image(:src="response_hash.url")

      template(v-if="xconv_info")
        .columns
          .column
            .level_container
              nav.level.is-mobile
                .level-item.has-text-centered
                  div
                    p.heading 待ち
                    p.title {{xconv_info.standby_only_count}}
                .level-item.has-text-centered(v-if="xconv_info.processing_only_count > 0 || true")
                  div
                    p.heading 変換中
                    p.title {{xconv_info.processing_only_count}}
                .level-item.has-text-centered
                  div
                    p.heading 完了
                    p.title {{xconv_info.success_only_count}}
                .level-item.has-text-centered(v-if="xconv_info.error_only_count > 0 || true")
                  div
                    p.heading 失敗
                    p.title {{xconv_info.error_only_count}}

            b-table(
              v-if="xconv_info.xconv_records.length >= 1"
              :data="xconv_info.xconv_records"
              :mobile-cards="false"
              :paginated="false"
              :per-page="10"
              )
              b-table-column(v-slot="{row}" label="予約ID" numeric)
                template(v-if="xconv_record && xconv_record.id === row.id")
                  b-tag(rounded type="is-primary") {{row.id}}
                template(v-else)
                  b-tag(rounded) {{row.id}}
              b-table-column(v-slot="{row}" field="name" label="名前")
                | {{row.user.name}}
              b-table-column(v-slot="{row}" field="status_info.name" label="ステイタス")
                | {{row.status_info.name}}

  DebugPre(v-if="development_p")
    | {{done_record}}
    | {{response_hash}}
</template>

<script>
//- const AUTO_APP_TO = true

import { support_parent   } from "./support_parent.js"
import { app_chore        } from "./app_chore.js"
import { app_preview        } from "./app_preview.js"
import { app_sidebar      } from "./app_sidebar.js"
import { app_action_cable } from "./app_action_cable.js"
import { app_form         } from "./app_form.js"
//- import { FormatTypeInfo } from "@/components/models/format_type_info.js"

import _ from "lodash"

export default {
  name: "XconvApp",
  mixins: [
    support_parent,
    app_chore,
    app_preview,
    app_sidebar,
    app_action_cable,
    app_form,
  ],

  data() {
    return {
      // データ
      response_hash:   null, // FreeBattle のインスタンスの属性たち + いろいろんな情報
      xconv_info:   null,
      xconv_record: null,

      // その他
      // change_counter: 0, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
    }
  },
  mounted() {
    this.ga_click("アニメーション変換")
  },
  computed: {
    base() { return this },
    meta() {
      return {
        title: "アニメーション変換",
        description: "棋譜をアニメーション形式に変換する",
        og_image_key: "xconv",
      }
    },
  },
}

</script>

<style lang="sass">
.XconvApp
  .MainSection.section
    +tablet
      padding: 2rem

  .MainColumn
    // +tablet
    //   max-width: 40rem

</style>
