<template lang="pug">
DebugBox.SbDebugVarPanel.is-hidden-mobile(v-if="SB.debug_mode_p")
  p 部屋状態: {{SB.cable_p}}
  p 横板状態: {{SB.sidebar_p}}
  p 本譜状態: {{SB.honpu_stage_info.name}}
  p 面子人数: {{SB.member_infos.length}}
  p 面子圧縮: {{SB.uniq_member_infos.length}}
  p モーダル: {{SB.g_modal_instance_count}}
  p 終了文脈: {{!!SB.ending_context}}
  p 画像DL数: {{SB.image_download_success_count}}
  p 千日手数: {{SB.perpetual_cop.count}}
  p 先輩度数: {{SB.active_level}}
  p connection_id: {{SB.connection_id}}
  p client_token: {{SB.client_token}}
  p session_counter: {{SB.session_counter}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbDebugVarPanel",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./stylesheets/support"
.SbDebugVarPanel
  __css_keep__: 0
</style>
