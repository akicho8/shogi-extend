<template lang="pug">
.SbDebugThinkMark.column.is-3
  .panel
    .panel-heading
      | 思考印
    a.panel-block(@click="SB.think_mark_toggle_button_click_handle") 切り替え
    a.panel-block(@click="SB.think_mark_all_clear") 全消し
    a.panel-block(href="?body=position sfen ln3gsnl/1r2g1kb1/2ppsp1p1/p3p1p1p/1p7/P1RPS3P/BPN1PPPP1/4G1SK1/L4G1NL b P 1&think_mark_list_str=5_6,ありす,0,6_5,ありす,0,black_P,ぼぶ,10,7_2,ぼぶ,10,5_6,きゃろる,2,4_5,きゃろる,2,3_4,きゃろる,2,4_7,でいぶ,3,4_6,でいぶ,3,5_6,でいぶ,3,9_9,えれん,4,9_8,えれん,4,4_1,ふらんく,5,3_1,ふらんく,5,8_2,いぶ,6,7_2,いぶ,6,9_4,あいざっく,7,9_5,あいざっく,7,7_7,ちゃーりー,8,6_5,ちゃーりー,8,9_7,まろりー,9,5_3,まろりー,9,3_2,おすかー,11,1_1,おすかー,11") デモ1 石田流
    a.panel-block(href="?body=position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b 7i8h 8c8d 2g2f 8d8e 2f2e 2b3c 3i4h 7a7b 6i7h 7c7d 5i6i 8e8f 8g8f 8b8f&think_mark_list_str=9_5,ありす,0,5_1,ありす,0,black_B,ありす,0,black_B,ぼぶ,0,7_7,ぼぶ,1") デモ2 王手飛車
    a.panel-block(@click="SB.to_sp_think_mark_list_str") シリアライズ
  .panel.assert_var
    .panel-heading
      | [assert_var]
    .panel-block think_mark_mode_p:{{SB.think_mark_mode_p}}
    //- .panel-block think_mark_mode_global_p:{{SB.think_mark_mode_global_p}}
    .panel-block think_mark_receive_scope_key:{{SB.think_mark_receive_scope_key}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugThinkMark",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugThinkMark
  __css_keep__: 0
</style>
