<template lang="pug">
.SbDebug.columns.is-multiline
  .column.is-3
    .panel
      .panel-heading
        | コンテキスト変更1
      a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a,b,c")                                                                     🔴順番 🔴時計 入室 a
      a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a,b,c&FIXED_ORDER=a,b")                                                     🟢順番 🔴時計 先手 a
      a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a,b,c&room_after_create=cc_auto_start_10m")                                 🔴順番 🟢時計 先手 a
      a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a,b,c&FIXED_ORDER=a,b&room_after_create=cc_auto_start_10m")                 🟢順番 🟢時計 先手 a
      a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=b&FIXED_MEMBER=a,b,c&FIXED_ORDER=a,b&room_after_create=cc_auto_start_10m")                 🟢順番 🟢時計 後手 b
      a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=c&FIXED_MEMBER=a,b,c&FIXED_ORDER=a,b&room_after_create=cc_auto_start_10m")                 🟢順番 🟢時計 観戦 c
      a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&FIXED_ORDER_SWAP=true&room_after_create=cc_auto_start_10m") 🟢順番 🟢時計 後手 a ※先手不明
      a.panel-block(href="?self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&FIXED_ORDER_SWAP=true&room_after_create=cc_auto_start_10m")  🟢順番 🟢時計 後手 a ※先手不明 自分vs自分 可
  .column.is-2
    .panel
      .panel-heading
        | ハンドルネーム関連
      a.panel-block(href="?ng_word_check_p=true") 「NGワードチェック」有効化
      a.panel-block(@click="SB.handle_name_modal_open_handle") 入力
      a.panel-block(@click="SB.handle_name_alert") 変更禁止警告
      a.panel-block(@click="SB.handle_name_clear") 空にする
  .column.is-3
    .panel
      .panel-heading
        | コンテキスト変更2
      a.panel-block(href="?room_key=dev_room&user_name=a&url_room_key_exist_behavior=modal_open") 合言葉ありURL時はモーダル表示で止める
  .column.is-2
    .panel
      .panel-heading
        | ActionCable
      a.panel-block(@click="SB.room_create") 接続
      a.panel-block(@click="SB.room_recreate") 再起動
      a.panel-block(@click="SB.room_destroy") 切断
      a.panel-block(@click="SB.fake_error") 値null送信
  .column.is-1
    .panel
      .panel-heading
        | ネット
      a.panel-block.internet_off_trigger(@click="SB.internet_off_trigger") OFF
      a.panel-block.internet_on_trigger(@click="SB.internet_on_trigger") ON

  SbDebugResign
  SbDebugAvatar
  SbDebugRoom
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


  SbDebugPerpetual
  SbDebugBasic
  .column.is-12
    SbDebugFes
  .column.is-12
    SbDebugOrder
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
        .panel-block {{e.room_joined_at}} {{e.from_user_name}} ({{e.client_token}} {{e.from_session_counter}} {{e.from_connection_id}})
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
      a.panel-block(@click="SB.edit_warn_modal_open") 編集警告
      a.panel-block(@click="SB.al_test") 指し手
      a.panel-block(@click="SB.clock_box_share('cc_behavior_manual_sync')") 時計同期
      a.panel-block(@click="SB.app_force_reload_notify_modal_open") リロード確認
      a.panel-block(@click="SB.room_entry_call({from_user_name: 'alice'})") 入室コール
      a.panel-block(@click="SB.run_or_room_out_confirm()") 退室確認
      a.panel-block(@click="SB.order_modal_close_confirm()") 順番設定を保存せずに閉じた警告モーダル
      a.panel-block(@click="SB.cc_play_confirm()") 順番設定OFFのまま時計開始警告モーダル
      a.panel-block(@click="SB.cc_next_message") 順番設定後に時計設置を促す
      a.panel-block(@click="SB.tn_bell_call") 牛
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
      a.panel-block(@click="SB.illegal_modal_open_handle(['駒ワープ', '王手放置'])") 全体

  .column.is-2
    .panel
      .panel-heading
        | 時計情報永続化
      a.panel-block(@click="SB.cc_params_load") ロード
      a.panel-block(@click="SB.cc_params_save") 保存
      a.panel-block(@click="SB.cc_params_reset") リセット
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
        | clock_share_dto
      .panel-block
        pre {{JSON.stringify(SB.clock_share_dto, null, 4)}}
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
        template(v-for="(e, i) in SB.AvatarSupport.showcase_default_chars")
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
