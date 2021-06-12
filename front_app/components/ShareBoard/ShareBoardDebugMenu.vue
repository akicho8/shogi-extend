<template lang="pug">
.columns.is-multiline.ShareBoardDebugMenu
  .column.is-6(v-if="base.clock_box")
    ClockBoxInspector(:clock_box="base.clock_box")
  .column.is-2
    .panel
      .panel-heading
        | 時間切れメソッド
      a.panel-block(@click="base.cc_time_zero_callback") 最初のコールバック
      a.panel-block(@click="base.cc_time_limit_modal_show_and_broadcast") 当事者は自分で発動＆BC
      a.panel-block(@click="base.cc_delayed_time_limit_modal") 他者は数秒後発動
      a.panel-block(@click="base.time_limit_modal_handle_if_not_exist") 受信
      a.panel-block(@click="base.cc_auto_time_limit_delay_stop") 数秒後発動キャンセル
      a.panel-block(@click="base.time_limit_modal_handle") モーダル
      a.panel-block(@click="base.time_limit_modal_close") 閉じる
  .column.is-2
    .panel
      .panel-heading
        | その他
      a.panel-block(@click="base.handle_name_modal_handle") ハンドルネーム入力
      a.panel-block(@click="base.handle_name_clear_handle") ハンドルネームを空にする
      a.panel-block(@click="base.edit_warn_modal_handle") 編集警告
      a.panel-block(@click="base.member_info_bc_restart") 生存通知
      a.panel-block(@click="base.al_add_test") 指し手
      a.panel-block(@click="base.clock_box_share()") 時計同期
      a.panel-block(@click="base.reload_modal_handle") リロード確認
      a.panel-block(@click="base.room_entry_call('alice')") 入室コール
      a.panel-block(@click="base.room_leave_call('alice')") 退室コール
      a.panel-block(:href="base.json_debug_url") JSON確認
  .column.is-2
    .panel
      .panel-heading
        | 時計パラメータ永続化
      a.panel-block(@click="base.cc_params_load") ロード
      a.panel-block(@click="base.cc_params_save") 保存
      a.panel-block(@click="base.cc_params_reset") リセット
  .column.is-2
    .panel
      .panel-heading
        | ActionCable
      a.panel-block(@click="base.room_recreate") 再起動
      a.panel-block(@click="base.room_create") 接続
      a.panel-block(@click="base.room_destroy") 切断
      a.panel-block(@click="base.fake_error") 値null送信
  .column.is-4
    .panel
      .panel-heading
        | JS側で作成 プレビュー用
      .panel-block
        p.is_line_break_on(:key="base.twitter_card_url") {{base.twitter_card_url}}
        img.is-block(:src="base.twitter_card_url" width="256")
  .column.is-4
    .panel
      .panel-heading
        | Rails側で作成 og:image 用
      .panel-block
        p.is_line_break_on {{$config.MY_SITE_URL + base.config.twitter_card_options.image}}
        img.is-block(:src=`$config.MY_SITE_URL + base.config.twitter_card_options.image` width="256")
  .column.is-3
    .panel
      .panel-heading
        | JSON
      .panel-block
        pre {{JSON.stringify(base.record, null, 4)}}
  .column.is-6.is-clipped
    .panel
      .panel-heading
        | TrackLog
      .panel-block
        ShareBoardTrackLog(:base="base")
//- DebugPre(v-if="development_p") {{$data}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardDebugMenu",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardDebugMenu
</style>
