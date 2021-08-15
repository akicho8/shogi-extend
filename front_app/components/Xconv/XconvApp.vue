<template lang="pug">
.XconvApp
  DebugBox(v-if="development_p")
    div foo:

  XconvSidebar(:base="base")
  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(@click="reset_handle") アニメーション変換
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink
      b-navbar-item.px_5_if_tablet.sidebar_toggle_navbar_item(@click="base.sidebar_toggle" v-if="development_p")
        b-icon(icon="menu")

  MainSection
    .container
      .columns.is-multiline.is-centered.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
        XconvForm(:base="base" ref="XconvForm" v-if="form_show_p")
        XconvReview(:base="base")
        XconvValidation(:base="base")
        .column.is-half
          b-tabs.list_tabs(expanded type="is-boxed" v-model="list_tab_index" @input="sound_play('click')")
            b-tab-item(label="あなた")
              XconvQueueSelf(:base="base")
            b-tab-item(label="みんな")
              XconvQueueAll(:base="base")

  XconvDebugPanels(:base="base" v-if="development_p")
</template>

<script>
//- const AUTO_APP_TO = true

import { support_parent   } from "./support_parent.js"
import { app_chore        } from "./app_chore.js"
import { app_review        } from "./app_review.js"
import { app_sidebar      } from "./app_sidebar.js"
import { app_action_cable } from "./app_action_cable.js"
import { app_queue_all } from "./app_queue_all.js"
import { app_queue_self } from "./app_queue_self.js"
import { app_form         } from "./app_form.js"
import { app_probe_show         } from "./app_probe_show.js"
import { app_foo_show         } from "./app_foo_show.js"

import { XconvRecord } from "./models/xconv_record.js"

//- import { FormatTypeInfo } from "@/components/models/format_type_info.js"

import _ from "lodash"

export default {
  name: "XconvApp",
  mixins: [
    support_parent,
    app_chore,
    app_review,
    app_sidebar,
    app_action_cable,
    app_queue_all,
    app_queue_self,
    app_form,
    app_probe_show,
    app_foo_show,
  ],

  data() {
    return {
      list_tab_index: 0,   // 変換リスト切り替えタブ (本来不要なはずだけど v-model を指定しないとマウント時に中身が反映されない)
      response_hash: null, // FreeBattle のインスタンスの属性たち + いろいろんな情報
    }
  },
  mounted() {
    this.ga_click("アニメーション変換")
  },
  computed: {
    base() { return this },
    XconvRecord() { return XconvRecord },
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

  .list_tabs
    .tab-content
      padding: 0.75rem 0

  // .MainColumn
  //   // +tablet
  //   //   max-width: 40rem

.STAGE-development
  .XconvApp
    .columns
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
