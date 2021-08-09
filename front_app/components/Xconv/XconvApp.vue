<template lang="pug">
.XconvApp
  DebugBox(v-if="development_p")
    div foo:

  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(@click="reset_handle") アニメーション変換
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink

  MainSection
    .container
      XconvForm(:base="base" ref="XconvForm" v-if="form_show_p")
      XconvReview(:base="base")
      XconvQueueWatch(:base="base")

  XconvDebugPanels(:base="base" v-if="development_p")
</template>

<script>
//- const AUTO_APP_TO = true

import { support_parent   } from "./support_parent.js"
import { app_chore        } from "./app_chore.js"
import { app_review        } from "./app_review.js"
import { app_sidebar      } from "./app_sidebar.js"
import { app_action_cable } from "./app_action_cable.js"
import { app_queue_watch } from "./app_queue_watch.js"
import { app_form         } from "./app_form.js"
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
    app_queue_watch,
    app_form,
  ],

  data() {
    return {
      // データ
      response_hash:   null, // FreeBattle のインスタンスの属性たち + いろいろんな情報

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

  // .MainColumn
  //   // +tablet
  //   //   max-width: 40rem

</style>
