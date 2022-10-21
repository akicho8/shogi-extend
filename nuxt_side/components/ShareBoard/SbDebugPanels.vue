<template lang="pug">
.columns.is-multiline.SbDebugPanels
  .column.is-2
    .panel
      .panel-heading
        | メダル
      .panel-block
        b-button(size="is-small" @click="base.medal_plus_handle('black', 1)") ☗+1
        b-button(size="is-small" @click="base.medal_plus_handle('black', -1)") ☗-1
        b-button(size="is-small" @click="base.medal_plus_handle('white', 1)") ☖+1
        b-button(size="is-small" @click="base.medal_plus_handle('white', -1)") ☖-1
      .panel-block
        b-button(size="is-small" @click="base.medal_plus_to_user_handle(base.user_name, 1)") 俺+1
        b-button(size="is-small" @click="base.medal_plus_to_user_handle(base.user_name, -1)") 俺-1
      .panel-block
        pre {{base.medal_counts_hash}}
  .column.is-12
    SbOrderPanel
  .column.is-6(v-if="base.clock_box")
    ClockBoxInspector(:clock_box="base.clock_box")
  .column.is-2
    .panel
      .panel-heading
        | メンバー情報通知<br>{{base.member_bc_status}}
      a.panel-block(@click="base.member_bc_create") create
      a.panel-block(@click="base.member_bc_destroy") destroy
      a.panel-block(@click="base.member_bc_restart") restart
      a.panel-block(@click="base.member_bc_stop") stop
      a.panel-block(@click="base.member_bc_callback") callback
  .column.is-4
    .panel
      .panel-heading
        | メンバーリスト({{base.member_infos.length}})
      template(v-for="e in base.member_infos")
        .panel-block {{e.room_joined_at}} {{e.from_user_name}} ({{e.from_session_id}} {{e.from_session_counter}} {{e.from_connection_id}})
  .column.is-4
    .panel
      .panel-heading
        | 無音化不具合検証用
      a.panel-block(@click="base.sound_resume_modal_handle") 画面タップ催促表示確認
      a.panel-block(@click="base.sound_resume_modal_close") 画面タップ催促閉じる
      a.panel-block(@click="base.sound_bug_start") ガヤ開始
      a.panel-block(@click="base.sound_bug_stop") ガヤ停止
      a.panel-block(v-if="base.sb_counter") ガヤ回数 {{base.sb_counter.counter}}
      a.panel-block(@click="Howler.mute(true)") mute(true)
      a.panel-block(@click="Howler.mute(false)") mute(false)
      a.panel-block(@click="Howler.volume(0)") volume(0)
      a.panel-block(@click="Howler.volume(1.0)") volume(1.0)
      a.panel-block(@click="Howler.stop()") stop()
      a.panel-block(@click="Howler.unload()") unload() 重要
      a.panel-block(@click="Howler.autoUnlock = true") autoUnlock = true
      a.panel-block(@click="Howler.autoSuspend = true") autoSuspend = true
      a.panel-block(@click="Howler.autoSuspend = false") autoSuspend = false
      a.panel-block Howler.volume() → {{Howler.volume()}}
      a.panel-block Howler.usingWebAudio → {{Howler.usingWebAudio}}
      a.panel-block Howler.noAudio → {{Howler.noAudio}}
      a.panel-block Howler.autoUnlock → {{Howler.autoUnlock}}
      a.panel-block Howler.html5PoolSize → {{Howler.html5PoolSize}}
      a.panel-block Howler.autoSuspend → {{Howler.autoSuspend}}
      a.panel-block Howler.ctx → {{pretty_inspect(Howler.ctx)}}
      a.panel-block Howler.masterGain → {{Howler.masterGain}}
      a.panel-block Howler._howls.length → {{Howler._howls.length}}

  .column.is-2
    .panel
      .panel-heading
        | system_test
      a.panel-block(@click="base.setup_info_request") [入室時の情報要求]

  .column.is-2
    .panel
      .panel-heading
        | 時間切れ
      a.panel-block(@click="base.cc_time_zero_callback") 最初のコールバック
      a.panel-block(@click="base.cc_timeout_modal_show_and_broadcast") 当事者は自分で発動＆BC
      a.panel-block(@click="base.cc_delayed_timeout_modal") 他者は数秒後発動
      a.panel-block(@click="base.timeout_modal_handle_if_not_exist") 受信
      a.panel-block(@click="base.cc_auto_timeout_delay_stop") 数秒後発動キャンセル
      a.panel-block(@click="base.timeout_modal_handle('self_notification')") モーダル(自首)
      a.panel-block(@click="base.timeout_modal_handle('audo_judgement')") モーダル(判定)
      a.panel-block(@click="base.timeout_modal_close") 閉じる
  .column.is-2
    .panel
      .panel-heading
        | その他
      a.panel-block(@click="base.handle_name_modal_handle") ハンドルネーム入力
      a.panel-block(@click="base.handle_name_alert") 順番設定中のハンドルネーム入力
      a.panel-block(@click="base.handle_name_clear_handle") ハンドルネームを空にする
      a.panel-block(@click="base.edit_warn_modal_handle") 編集警告
      a.panel-block(@click="base.al_add_test") 指し手
      a.panel-block(@click="base.clock_box_share('ck_manual_sync')") 時計同期
      a.panel-block(@click="base.reload_modal_handle") リロード確認
      a.panel-block(@click="base.room_entry_call({from_user_name: 'alice'})") 入室コール
      a.panel-block(@click="base.room_leave_call({from_user_name: 'alice'})") 退室コール
      a.panel-block(@click="base.run_or_room_out_confirm()") 退室確認
      a.panel-block(@click="base.os_modal_close_confirm()") 順番設定を保存せずに閉じた警告モーダル
      a.panel-block(@click="base.cc_play_confirm()") 順番設定OFFのまま時計開始警告モーダル
      a.panel-block(@click="base.cc_next_message") 順番設定後に時計設置を促す
      a.panel-block(@click="base.tn_notify") 牛
      a.panel-block(@click="base.kifu_mail_handle") 棋譜メール
  .column.is-2
    .panel
      .panel-heading
        | 将棋盤
      a.panel-block(@click="base.sp_state_reset") 持ち上げた駒を元に戻す
      a.panel-block(@click="base.sp_viewpoint = 'black'") ☗視点
      a.panel-block(@click="base.sp_viewpoint = 'white'") ☖視点
      .panel-block 現在の視点 {{base.sp_viewpoint}}

  .column.is-2
    .panel
      .panel-heading
        | 反則指摘
      a.panel-block(@click="base.foul_accident_handle({name: '二歩'})") 自分
      a.panel-block(@click="base.foul_modal_handle(['駒ワープ', '王手放置'])") 全体

  .column.is-2
    .panel
      .panel-heading
        | 時計情報永続化
      a.panel-block(@click="base.cc_params_load") ロード
      a.panel-block(@click="base.cc_params_save") 保存
      a.panel-block(@click="base.cc_params_reset") リセット
  .column.is-2
    .panel
      .panel-heading
        | 投了
      a.panel-block(@click="base.toryo_confirm_handle") 投了確認ボタン
      a.panel-block(@click="base.toryo_run_from_modal") 投了ボタン(バリデーションあり)
      a.panel-block(@click="base.toryo_direct_run") 投了実処理
  .column.is-2
    .panel
      .panel-heading
        | ActionCable
      a.panel-block(@click="base.room_recreate") 再起動
      a.panel-block(@click="base.room_create") 接続
      a.panel-block(@click="base.room_destroy") 切断
      a.panel-block(@click="base.fake_error") 値null送信
  .column.is-3
    .panel
      .panel-heading
        | JSON
      a.panel-block(:href="base.json_debug_url") JSON確認
      .panel-block
        pre {{JSON.stringify(base.record, null, 4)}}
  .column.is-3
    .panel.is_line_break_on
      .panel-heading
        | SFEN
      .panel-block 操作 {{base.current_sfen}}
      .panel-block 編集 {{base.edit_mode_sfen}}
  .column.is-3
    .panel
      .panel-heading
        | ls_attributes
      .panel-block
        pre {{JSON.stringify(base.ls_attributes, null, 4)}}
  .column.is-3
    .panel
      .panel-heading
        | current_xclock
      .panel-block
        pre {{JSON.stringify(base.current_xclock, null, 4)}}
  .column.is-3
    .panel
      .panel-heading
        | 棋譜追加情報
      .panel-block.is-flex-direction-column
        p player_names_from_member
        pre {{JSON.stringify(base.player_names_from_member, null, 4)}}
      .panel-block.is-flex-direction-column
        p player_names_from_query
        pre {{JSON.stringify(base.player_names_from_query, null, 4)}}
      .panel-block.is-flex-direction-column
        p player_names_with_title_as_human_text
        pre {{base.player_names_with_title_as_human_text}}
  .column.is-4
    .panel
      .panel-heading
        | JS側で作成 プレビュー用
      .panel-block
        p.is_line_break_on(:key="base.twitter_card_url") {{base.twitter_card_url}}
      .panel-block
        a(:href="base.twitter_card_url" target="_blank") 確認
  .column.is-4
    .panel
      .panel-heading
        | Rails側で作成 og:image 用
      .panel-block
        p.is_line_break_on {{$config.MY_SITE_URL + base.config.twitter_card_options.image}}
      .panel-block
        a(:href=`$config.MY_SITE_URL + base.config.twitter_card_options.image` target="_blank") 確認
  .column.is-4
    .panel.assert_system_variable
      .panel-heading
        | [assert_system_variable]
      .panel-block tn_counter:{{base.tn_counter}}
      .panel-block current_turn:{{base.current_turn}}
      .panel-block clock_box:{{!!base.clock_box}}
      .panel-block clock_box.current_status:{{base.clock_box ? base.clock_box.current_status : ''}}
      .panel-block current_title:{{base.current_title}}
      .panel-block cc_params:{{base.cc_params_inspect(base.cc_params)}}
      .panel-block next_turn_message:{{base.next_turn_message}}
      .panel-block latest_foul_name:{{base.latest_foul_name}}
      .panel-block abstract_viewpoint:{{base.abstract_viewpoint}}

  .column.is-6.is-clipped
    .panel
      .panel-heading
        | TrackLog
      .panel-block
        SbTrackLog(:base="base")
  .column.is-12
    .panel
      .panel-heading
        | 絵文字
      .panel-block.is-block
        template(v-for="(e, i) in base.guardian_list")
          span.mx-1(v-xemoji) {{i}}:{{e}}
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "SbDebugPanels",
  mixins: [support_child],
  computed: {
    Howler() { return window.Howler },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.SbDebugPanels
  .xemoji
    height: 4rem
    width: unset
  .panel
    background-color: $white
</style>
