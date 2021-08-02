<template lang="pug">
.GifConvApp
  DebugBox(v-if="development_p")
    div foo:

  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(@click="reset_handle") アニメーションGIF変換

  MainSection
    .container
      GifConvPreview(:base="base")
      GifConvForm(:base="base" ref="GifConvForm" v-if="form_show_p")

      template(v-if="response_hash && response_hash.url")
        .columns
          .column
            .box
              b-image(:src="response_hash.url")

      template(v-if="teiki_haisin")
        .columns
          .column
            .level_container
              nav.level.is-mobile
                .level-item.has-text-centered
                  div
                    p.heading 待ち
                    p.title {{teiki_haisin.unprocessed_count}}
                .level-item.has-text-centered
                  div
                    p.heading 変換中
                    p.title {{teiki_haisin.processing_count}}
                .level-item.has-text-centered
                  div
                    p.heading 完了
                    p.title {{teiki_haisin.processed_count}}

            b-table(
              v-if="teiki_haisin.henkan_records.length >= 1"
              :data="teiki_haisin.henkan_records"
              :mobile-cards="false"
              :paginated="false"
              :per-page="10"
              )
              b-table-column(v-slot="{row}" label="予約ID" numeric)
                template(v-if="henkan_record && henkan_record.id === row.id")
                  b-tag(rounded type="is-primary") {{row.id}}
                template(v-else)
                  | {{row.id}}
              b-table-column(v-slot="{row}" field="name" label="名前")
                | {{row.user.name}}
              b-table-column(v-slot="{row}" field="status_name" label="ステイタス")
                | {{row.status_name}}

  DebugPre(v-if="development_p")
    | {{success_record}}
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
  name: "GifConvApp",
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
      teiki_haisin:   null,
      henkan_record: null,

      // その他
      // change_counter: 0, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
    }
  },
  mounted() {
    this.ga_click("アニメーションGIF変換")
  },
  computed: {
    base() { return this },
    meta() {
      return {
        title: "アニメーションGIF変換",
        description: "棋譜をアニメーションGIFに変換する",
        og_image_key: "gif_conv",
      }
    },
  },
}

</script>

<style lang="sass">
.GifConvApp
  .MainSection.section
    +tablet
      padding: 2rem

  .MainColumn
    // +tablet
    //   max-width: 40rem

</style>
