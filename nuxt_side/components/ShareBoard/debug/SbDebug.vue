<template lang="pug">
.SbDebug.columns.is-multiline
  SbDebugRoomLatestStateLoader
  SbDebugXprofile
  SbDebugHonpu
  SbDebugThinkMark
  SbDebugChat

  .column.is-2
    .panel
      .panel-heading
        | 時間切れ
      a.panel-block.cc_timeout_trigger(@click="SB.cc_timeout_trigger") 最初のコールバック
      a.panel-block(@click="SB.cc_timeout_modal_show_and_broadcast") 当事者は自分で発動＆BC
      a.panel-block(@click="SB.cc_timeout_modal_show_later") 他者は数秒後発動
      a.panel-block(@click="SB.cc_timeout_modal_open_if_not_exist") 受信
      a.panel-block(@click="SB.cc_timeout_judge_delay_stop") 数秒後発動キャンセル
      a.panel-block(@click="SB.cc_timeout_modal_open('self_notify')") モーダル(自首)
      a.panel-block(@click="SB.cc_timeout_modal_open('audo_judge')") モーダル(判定)
      a.panel-block(@click="SB.cc_timeout_modal_close") 閉じる

  SbDebugClock
  SbDebugDashboard

  .column.is-2
    .panel
      .panel-heading
        | 投了
      a.panel-block(@click="SB.give_up_modal_open_handle") 投了確認ボタン
      a.panel-block(@click="SB.give_up_direct_run_with_valid") 投了ボタン(バリデーションあり)
      a.panel-block(@click="SB.give_up_direct_run") 投了実処理
  .column.is-2
    .panel
      .panel-heading
        | 保存
      a.panel-block(@click="SB.battle_save_run") 対局保存
  SbDebugPerpetual
  SbDebugBasic
  .column.is-12
    SbFesPanel
  .column.is-12
    SbDebugOrder
  SbDebugRoomUrlCopyModal
  .column.is-6(v-if="SB.clock_box")
    ClockBoxInspector(:clock_box="SB.clock_box")
  .column.is-2
    .panel
      .panel-heading
        | メンバー情報通知<br>{{SB.member_bc_status}}
      a.panel-block(@click="SB.member_bc_create") create
      a.panel-block(@click="SB.member_bc_destroy") destroy
      a.panel-block(@click="SB.member_bc_restart") restart
      a.panel-block(@click="SB.member_bc_stop") stop
      a.panel-block(@click="SB.member_bc_callback") callback
  .column.is-4
    .panel
      .panel-heading
        | メンバーリスト({{SB.member_infos.length}})
      template(v-for="e in SB.member_infos")
        .panel-block {{e.room_joined_at}} {{e.from_user_name}} ({{e.from_session_id}} {{e.from_session_counter}} {{e.from_connection_id}})
  SbDebugHowler
  .column.is-2
    .panel
      .panel-heading
        | system_test
      a.panel-block(@click="SB.setup_info_request") [入室時の情報要求]

  .column.is-2
    .panel
      .panel-heading
        | その他
      a.panel-block(@click="SB.handle_name_modal_handle") ハンドルネーム入力
      a.panel-block(@click="SB.handle_name_alert") 順番設定中のハンドルネーム入力
      a.panel-block(@click="SB.handle_name_clear_handle") ハンドルネームを空にする
      a.panel-block(@click="SB.edit_warn_modal_handle") 編集警告
      a.panel-block(@click="SB.al_test") 指し手
      a.panel-block(@click="SB.clock_box_share('cc_behavior_manual_sync')") 時計同期
      a.panel-block(@click="SB.reload_modal_handle") リロード確認
      a.panel-block(@click="SB.room_entry_call({from_user_name: 'alice'})") 入室コール
      a.panel-block(@click="SB.room_leave_call({from_user_name: 'alice'})") 退室コール
      a.panel-block(@click="SB.run_or_room_out_confirm()") 退室確認
      a.panel-block(@click="SB.os_modal_close_confirm()") 順番設定を保存せずに閉じた警告モーダル
      a.panel-block(@click="SB.cc_play_confirm()") 順番設定OFFのまま時計開始警告モーダル
      a.panel-block(@click="SB.cc_next_message") 順番設定後に時計設置を促す
      a.panel-block(@click="SB.tn_notify") 牛
      a.panel-block(@click="SB.kifu_mail_handle") 棋譜メール
      a.panel-block(@click="SB.ac_log({subject: 'ac_log', body: 'b', emoji: ':SOS:', level: 'critical'})") ac_log
      a.panel-block(@click="app_log({subject: 'app_log', body: 'b', emoji: ':SOS:', level: 'critical'})") app_log

  .column.is-2
    .panel
      .panel-heading
        | 将棋盤
      a.panel-block(@click="SB.sp_lifted_piece_cancel") 持ち上げた駒を元に戻す
      a.panel-block(@click="SB.viewpoint = 'black'") ☗視点
      a.panel-block(@click="SB.viewpoint = 'white'") ☖視点
      .panel-block 現在の視点 {{SB.viewpoint}}

  .column.is-2
    .panel
      .panel-heading
        | 反則指摘
      a.panel-block(@click="SB.ev_illegal_illegal_accident({name: '二歩'})") 自分
      a.panel-block(@click="SB.illegal_modal_handle(['駒ワープ', '王手放置'])") 全体

  .column.is-2
    .panel
      .panel-heading
        | 時計情報永続化
      a.panel-block(@click="SB.cc_params_load") ロード
      a.panel-block(@click="SB.cc_params_save") 保存
      a.panel-block(@click="SB.cc_params_reset") リセット
  .column.is-2
    .panel
      .panel-heading
        | ActionCable
      a.panel-block(@click="SB.room_recreate") 再起動
      a.panel-block(@click="SB.room_create") 接続
      a.panel-block(@click="SB.room_destroy") 切断
      a.panel-block(@click="SB.fake_error") 値null送信
  .column.is-3
    .panel
      .panel-heading
        | JSON
      a.panel-block(:href="SB.json_debug_url") JSON確認
      .panel-block
        pre {{JSON.stringify(SB.record, null, 4)}}
  .column.is-3
    .panel
      .panel-heading
        | SFEN
      .panel-block 操作 {{SB.current_sfen}}
      .panel-block 編集 {{SB.edit_mode_sfen}}
  .column.is-3
    .panel
      .panel-heading
        | ls_attributes
      .panel-block
        pre {{JSON.stringify(SB.ls_attributes, null, 4)}}
  .column.is-3
    .panel
      .panel-heading
        | clock_share_data
      .panel-block
        pre {{JSON.stringify(SB.clock_share_data, null, 4)}}
  .column.is-3
    .panel
      .panel-heading
        | 棋譜追加情報
      .panel-block.is-flex-direction-column
        p player_names_from_member
        pre {{JSON.stringify(SB.player_names_from_member, null, 4)}}
      .panel-block.is-flex-direction-column
        p player_names_from_query
        pre {{JSON.stringify(SB.player_names_from_query, null, 4)}}
      .panel-block.is-flex-direction-column
        p player_names_with_title_as_human_text
        pre {{SB.player_names_with_title_as_human_text}}
  .column.is-4
    .panel
      .panel-heading
        | JS側で作成 プレビュー用
      .panel-block
        p(:key="SB.twitter_card_url") {{SB.twitter_card_url}}
      .panel-block
        a(:href="SB.twitter_card_url" target="_blank") 確認
  .column.is-4
    .panel
      .panel-heading
        | Rails側で作成 og:image 用
      .panel-block
        p {{$config.MY_SITE_URL + SB.config.twitter_card_options.image}}
      .panel-block
        a(:href=`$config.MY_SITE_URL + SB.config.twitter_card_options.image` target="_blank") 確認
  .column.is-6.is-clipped
    .panel
      .panel-heading
        | TrackLog
      .panel-block
        TrackLogModalTable
  .column.is-12
    .panel
      .panel-heading
        | 絵文字
      .panel-block.is-block
        template(v-for="(e, i) in SB.guardian_list")
          span.mx-1(v-xemoji) {{i}}:{{e}}
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbDebug",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebug
  .xemoji
    height: 4rem
    width: unset
  .panel
    background-color: $white
</style>
