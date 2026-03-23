<template lang="pug">
DebugBox.SbDebugVarPanel.is-hidden-mobile(v-if="SB.debug_mode_p")
  p 部屋状態: {{SB.cable_p}}
  p 横板状態: {{SB.sidebar_p}}
  p 本譜状態: {{SB.honpu_stage_info.name}}
  p 面子人数: {{SB.member_infos.length}}
  p 面子圧縮: {{SB.uniq_member_infos.length}}
  p モーダル: {{SB.g_modal_instance_count}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbDebugVarPanel",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./sass/support.sass"
.SbDebugVarPanel
  __css_keep__: 0
</style>
