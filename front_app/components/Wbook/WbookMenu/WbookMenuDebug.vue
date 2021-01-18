<template lang="pug">
.WbookMenuDebug
  .primary_header
    .header_center_title デバッグモード
  .menu_buttons
    b-field
      b-switch(v-model="base.debug_summary_p") オンライン数の表示
    b-field
      b-switch(v-model="base.debug_force_edit_p") 他人の問題を編集
    b-field
      b-switch(v-model="base.debug_read_p") デバッグ情報の表示
    b-field
      b-switch(v-model="base.debug_write_p" type="is-danger") 破壊系を有効化

    b-button(expanded tag="a" :href="`${$config.MY_SITE_URL}/admin/script/user-switch`") 運営ユーザー切り替え
    b-button(expanded tag="a" :href="user_switch_direct_url('sysop')") → 運営
    b-button(expanded tag="a" :href="user_switch_direct_url('932ed39bb18095a2fc73e0002f94ecf1')") → きなこもち
    b-button(expanded tag="a" :href="user_switch_direct_url('bot')") → BOT
    b-button(expanded tag="a" :href="user_switch_direct_url('cdc5800125cd263735933b8419e09b36')") → わらびもち
    b-button(expanded @click="base.menu_to('WbookMenuEtc')") もどる
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "WbookMenuDebug",
  mixins: [
    support_child,
  ],
  methods: {
    user_switch_direct_url(user_key) {
      const params = new URLSearchParams()
      params.set("user_key", user_key)
      params.set("redirect_to", location.href)
      return `/admin/script/user_switch_direct?${params}`
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WbookMenuDebug
</style>
