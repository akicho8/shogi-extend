<template lang="pug">
.SbDebugPanels.columns.is-multiline
  .column.is-2
    .panel
      .panel-heading
        | 千日手指摘
      a.panel-block(@click="TheSb.snt_modal_handle(true)") 千日手指摘
  SbDebugPanelsBasic
  .column.is-12
    SbFesPanel
  .column.is-12
    SbDebugPanelsOrder
  SbDebugPanelsMedal
  SbDebugPanelsRoomUrlCopyModal
  .column.is-6(v-if="TheSb.clock_box")
    ClockBoxInspector(:clock_box="TheSb.clock_box")
  .column.is-2
    .panel
      .panel-heading
        | メンバー情報通知<br>{{TheSb.member_bc_status}}
      a.panel-block(@click="TheSb.member_bc_create") create
      a.panel-block(@click="TheSb.member_bc_destroy") destroy
      a.panel-block(@click="TheSb.member_bc_restart") restart
      a.panel-block(@click="TheSb.member_bc_stop") stop
      a.panel-block(@click="TheSb.member_bc_callback") callback
  .column.is-4
    .panel
      .panel-heading
        | メンバーリスト({{TheSb.member_infos.length}})
      template(v-for="e in TheSb.member_infos")
        .panel-block {{e.room_joined_at}} {{e.from_user_name}} ({{e.from_session_id}} {{e.from_session_counter}} {{e.from_connection_id}})
  SbDebugPanelsHowler
  .column.is-2
    .panel
      .panel-heading
        | system_test
      a.panel-block(@click="TheSb.setup_info_request") [入室時の情報要求]

  .column.is-2
    .panel
      .panel-heading
        | 時間切れ
      a.panel-block(@click="TheSb.cc_time_zero_callback") 最初のコールバック
      a.panel-block(@click="TheSb.cc_timeout_modal_show_and_broadcast") 当事者は自分で発動＆BC
      a.panel-block(@click="TheSb.cc_delayed_timeout_modal") 他者は数秒後発動
      a.panel-block(@click="TheSb.timeout_modal_handle_if_not_exist") 受信
      a.panel-block(@click="TheSb.cc_auto_timeout_delay_stop") 数秒後発動キャンセル
      a.panel-block(@click="TheSb.timeout_modal_handle('self_notification')") モーダル(自首)
      a.panel-block(@click="TheSb.timeout_modal_handle('audo_judgement')") モーダル(判定)
      a.panel-block(@click="TheSb.timeout_modal_close") 閉じる
  .column.is-2
    .panel
      .panel-heading
        | その他
      a.panel-block(@click="TheSb.handle_name_modal_handle") ハンドルネーム入力
      a.panel-block(@click="TheSb.handle_name_alert") 順番設定中のハンドルネーム入力
      a.panel-block(@click="TheSb.handle_name_clear_handle") ハンドルネームを空にする
      a.panel-block(@click="TheSb.edit_warn_modal_handle") 編集警告
      a.panel-block(@click="TheSb.al_add_test") 指し手
      a.panel-block(@click="TheSb.clock_box_share('ck_manual_sync')") 時計同期
      a.panel-block(@click="TheSb.reload_modal_handle") リロード確認
      a.panel-block(@click="TheSb.room_entry_call({from_user_name: 'alice'})") 入室コール
      a.panel-block(@click="TheSb.room_leave_call({from_user_name: 'alice'})") 退室コール
      a.panel-block(@click="TheSb.run_or_room_out_confirm()") 退室確認
      a.panel-block(@click="TheSb.os_modal_close_confirm()") 順番設定を保存せずに閉じた警告モーダル
      a.panel-block(@click="TheSb.cc_play_confirm()") 順番設定OFFのまま時計開始警告モーダル
      a.panel-block(@click="TheSb.cc_next_message") 順番設定後に時計設置を促す
      a.panel-block(@click="TheSb.tn_notify") 牛
      a.panel-block(@click="TheSb.kifu_mail_handle") 棋譜メール
  .column.is-2
    .panel
      .panel-heading
        | 将棋盤
      a.panel-block(@click="TheSb.sp_state_reset") 持ち上げた駒を元に戻す
      a.panel-block(@click="TheSb.viewpoint = 'black'") ☗視点
      a.panel-block(@click="TheSb.viewpoint = 'white'") ☖視点
      .panel-block 現在の視点 {{TheSb.viewpoint}}

  .column.is-2
    .panel
      .panel-heading
        | 反則指摘
      a.panel-block(@click="TheSb.foul_accident_handle({name: '二歩'})") 自分
      a.panel-block(@click="TheSb.foul_modal_handle(['駒ワープ', '王手放置'])") 全体

  .column.is-2
    .panel
      .panel-heading
        | 時計情報永続化
      a.panel-block(@click="TheSb.cc_params_load") ロード
      a.panel-block(@click="TheSb.cc_params_save") 保存
      a.panel-block(@click="TheSb.cc_params_reset") リセット
  .column.is-2
    .panel
      .panel-heading
        | 投了
      a.panel-block(@click="TheSb.give_up_confirm_handle") 投了確認ボタン
      a.panel-block(@click="TheSb.give_up_run_from_modal") 投了ボタン(バリデーションあり)
      a.panel-block(@click="TheSb.give_up_direct_run") 投了実処理
  .column.is-2
    .panel
      .panel-heading
        | ActionCable
      a.panel-block(@click="TheSb.room_recreate") 再起動
      a.panel-block(@click="TheSb.room_create") 接続
      a.panel-block(@click="TheSb.room_destroy") 切断
      a.panel-block(@click="TheSb.fake_error") 値null送信
  .column.is-3
    .panel
      .panel-heading
        | JSON
      a.panel-block(:href="TheSb.json_debug_url") JSON確認
      .panel-block
        pre {{JSON.stringify(TheSb.record, null, 4)}}
  .column.is-3
    .panel.is_line_break_on
      .panel-heading
        | SFEN
      .panel-block 操作 {{TheSb.current_sfen}}
      .panel-block 編集 {{TheSb.edit_mode_sfen}}
  .column.is-3
    .panel
      .panel-heading
        | ls_attributes
      .panel-block
        pre {{JSON.stringify(TheSb.ls_attributes, null, 4)}}
  .column.is-3
    .panel
      .panel-heading
        | current_xclock
      .panel-block
        pre {{JSON.stringify(TheSb.current_xclock, null, 4)}}
  .column.is-3
    .panel
      .panel-heading
        | 棋譜追加情報
      .panel-block.is-flex-direction-column
        p player_names_from_member
        pre {{JSON.stringify(TheSb.player_names_from_member, null, 4)}}
      .panel-block.is-flex-direction-column
        p player_names_from_query
        pre {{JSON.stringify(TheSb.player_names_from_query, null, 4)}}
      .panel-block.is-flex-direction-column
        p player_names_with_title_as_human_text
        pre {{TheSb.player_names_with_title_as_human_text}}
  .column.is-4
    .panel
      .panel-heading
        | JS側で作成 プレビュー用
      .panel-block
        p.is_line_break_on(:key="TheSb.twitter_card_url") {{TheSb.twitter_card_url}}
      .panel-block
        a(:href="TheSb.twitter_card_url" target="_blank") 確認
  .column.is-4
    .panel
      .panel-heading
        | Rails側で作成 og:image 用
      .panel-block
        p.is_line_break_on {{$config.MY_SITE_URL + TheSb.config.twitter_card_options.image}}
      .panel-block
        a(:href=`$config.MY_SITE_URL + TheSb.config.twitter_card_options.image` target="_blank") 確認
  .column.is-4
    .panel.assert_system_variable
      .panel-heading
        | [assert_system_variable]
      .panel-block tn_counter:{{TheSb.tn_counter}}
      .panel-block current_turn:{{TheSb.current_turn}}
      .panel-block clock_box:{{!!TheSb.clock_box}}
      .panel-block clock_box.current_status:{{TheSb.clock_box ? TheSb.clock_box.current_status : ''}}
      .panel-block current_title:{{TheSb.current_title}}
      .panel-block cc_params:{{TheSb.cc_params_inspect(TheSb.cc_params)}}
      .panel-block next_turn_message:{{TheSb.next_turn_message}}
      .panel-block latest_foul_name:{{TheSb.latest_foul_name}}
      .panel-block viewpoint:{{TheSb.viewpoint}}

  .column.is-6.is-clipped
    .panel
      .panel-heading
        | TrackLog
      .panel-block
        SbTrackLog
  .column.is-12
    .panel
      .panel-heading
        | 絵文字
      .panel-block.is-block
        template(v-for="(e, i) in TheSb.guardian_list")
          span.mx-1(v-xemoji) {{i}}:{{e}}
</template>

<script>
import _ from "lodash"

export default {
  name: "SbDebugPanels",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanels
  .xemoji
    height: 4rem
    width: unset
  .panel
    background-color: $white
</style>
