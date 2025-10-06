<template lang="pug">
.SbDebugXprofile.column.is-12
  .columns.is-multiline
    .column.is-6
      //- .panel
      //- .panel-heading
      //-   | バッジ
      //- .panel-block(v-if="SB.current_sfen") 現在 \#{{SB.current_turn}} {{SB.current_sfen}}
      //- .panel-block(v-if="SB.honpu_main") 本譜 \#{{SB.honpu_main.turn}} {{SB.honpu_main.sfen}}
      //- .panel-block(v-if="SB.honpu_branch") ブランチ \#{{SB.honpu_branch.turn}} {{SB.honpu_branch.sfen}}
      //- .panel-block 直近の指し手は本譜をなぞっている？ {{SB.honpu_branch_is_same_route_p}}
      //- .panel-block 直近の指し手は本譜から外れた？ {{SB.honpu_branch_exist_p}}
      //- a.panel-block.honpu_main_setup(@click="SB.honpu_main_setup") 作成
      //- a.panel-block.honpu_open_click_handle(@click="SB.honpu_open_click_handle") 開く
      //- a.panel-block.honpu_all_clear(@click="SB.honpu_all_clear") 削除
      .panel
        .panel-heading
          | 勝率情報
        a.panel-block(href="/share-board?room_key=dev_room1&user_name=alice&fixed_member_names=alice,bob&fixed_order_names=alice,bob&fixed_order_state=to_o2_state&autoexec=cc_auto_start") URL: 確認用の環境に変更する
        a.panel-block(@click="SB.xprofile_entry") xprofile_entry: [入室直前] 自分の情報をDBから受け取っていない状態にする (xprofile_loaded: {{SB.xprofile_loaded}})
        a.panel-block(@click="SB.xprofile_leave") xprofile_leave: [退室]
        a.panel-block(@click="SB.xprofile_load") xprofile_load: [接続] 自分の情報を取得する (DB → 全員)
        a.panel-block(@click="SB.xprofile_share") xprofile_share: [他者接続] 自分の情報を配布する (クライアント → 全員)
        a.panel-block(@click="SB.battle_save_by_win_location('black')") [投了] ☗側を勝ちとする (DB → 全員)
        a.panel-block(@click="SB.battle_save_by_win_location('white')") [投了] ☖勝を勝ちとする (DB → 全員)
        .panel-block users_match_record_master = {{SB.users_match_record_master}}
    .column.is-6
      .panel.assert_var
        .panel-heading
          | [assert_var]
        template(v-for="user_name in SB.room_user_names")
          .panel-block {{user_name}}.win_count:{{SB.xprofile_decorator_by_name(user_name).win_count}}
          .panel-block {{user_name}}.lose_count:{{SB.xprofile_decorator_by_name(user_name).lose_count}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugXprofile",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugXprofile
  __css_keep__: 0
</style>
