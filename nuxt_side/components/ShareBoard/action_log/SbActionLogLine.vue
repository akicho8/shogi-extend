<template lang="pug">
SbAvatarLine.SbActionLogLine.is-clickable(:info="e" tag="a" :key="e.unique_key" @click="SB.al_click_handle(e)" :xprofile_show_p="false")
  // タグ的なもの
  template(v-if="e.label")
    template(v-if="e.label_type")
      b-tag.flex_item(:type="e.label_type" size="is-small") {{e.label}}
    template(v-else)
      .flex_item {{e.label}}

  // 指し手
  template(v-if="e.last_move_info_attrs")
    .flex_item {{e.last_move_info_attrs.next_turn_offset}}
    .flex_item {{e.last_move_info_attrs.kif_without_from}}

  // 表示優先度: 反則←詰み←王手
  template(v-if="$GX.present_p(e.illegal_hv_list)")
    template(v-for="e in e.illegal_hv_list")
      b-tag.flex_item(type="is-danger" size="is-small") {{e.illegal_info.name}}
  template(v-else-if="SB.knock_out_p(e)")
    b-tag.flex_item(type="is-danger" size="is-small") 詰み
  template(v-else-if="e.op_king_check && !SB.cc_play_p")
    b-tag.flex_item(type="is-danger" size="is-small") 王手

  // 指すまでにかかった秒数
  .flex_item(v-if="'elapsed_sec' in e") {{-e.elapsed_sec}}秒

  // この情報を作った時間
  .flex_item.time_format(v-if="e.performed_at && development_p") {{e.display_time}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbActionLogLine",
  mixins: [support_child],
  props: ["e"],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbActionLogLine
  __css_keep__: 0
</style>
