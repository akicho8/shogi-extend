<template lang="pug">
.columns.is-multiline.ShareBoardDebugPanels
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
        .panel-block {{e.room_joined_at}} {{e.from_user_name}} ({{e.from_connection_id}})
  .column.is-2
    .panel
      .panel-heading
        | メンバーと順番
      .panel-block
        | 面子: {{base.member_infos.map(e => e.from_user_name).join(" ")}}
      //- .panel-block
      //-   | 順番: {{(base.ordered_members || []).map(e => e.user_name).join(" ")}}
      //- .panel-block
      //-   | 最終: {{base.visible_member_infos.map(e => e.from_user_name).join(" ")}}
      .panel-block
        pre {{base.player_names_with_title_as_human_text}}
  .column.is-4
    .panel
      .panel-heading
        | 順番設定 ({{base.order_enable_p}})
      //- template(v-for="e in (base.ordered_members || [])")
      //-   .panel-block {{e}}
  .column.is-4
    .panel
      .panel-heading
        | 順番情報(computed)
      .panel-block 自分vs自分で対戦している？ {{base.self_vs_self_p}}
      .panel-block 1vs1で対戦している？ {{base.one_vs_one_p}}
      .panel-block 3人以上で対戦している？ {{base.many_vs_many_p}}
      .panel-block 観戦者数 {{base.watching_member_count}}
      .panel-block メンバーリストが空？ {{base.omembers_blank_p}}
      .panel-block メンバーリストがある？ {{base.omembers_present_p}}
      .panel-block 今の局面のメンバーの名前 {{base.current_turn_user_name}}
      .panel-block 今は自分の手番か？ {{base.current_turn_self_p}}
      .panel-block 次の局面のメンバーの名前 {{base.next_turn_user_name}}
      .panel-block 次は自分の手番か？ {{base.next_turn_self_p}}
      .panel-block 前の局面のメンバーの名前 {{base.previous_turn_user_name}}
      .panel-block 前は自分の手番か？ {{base.previous_turn_self_p}}
      .panel-block 自分はメンバーに含まれているか？ {{base.self_is_member_p}}
      .panel-block 自分は観戦者か？ {{base.self_is_watcher_p}}
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

      template(v-if="base.sp_Howler()")
        //- a.panel-block base.sp_Howler().volume() → {{base.sp_Howler().volume()}}
        //- a.panel-block base.sp_Howler().usingWebAudio → {{base.sp_Howler().usingWebAudio}}
        //- a.panel-block base.sp_Howler().noAudio → {{base.sp_Howler().noAudio}}
        //- a.panel-block base.sp_Howler().autoUnlock → {{base.sp_Howler().autoUnlock}}
        //- a.panel-block base.sp_Howler().html5PoolSize → {{base.sp_Howler().html5PoolSize}}
        //- a.panel-block base.sp_Howler().autoSuspend → {{base.sp_Howler().autoSuspend}}
        //- a.panel-block base.sp_Howler().masterGain → {{base.sp_Howler().masterGain}}
        //- a.panel-block base.sp_Howler().ctx → {{pretty_inspect(base.sp_Howler().ctx)}}
        a.panel-block sp_Howler()._howls.length → {{base.sp_Howler()._howls.length}}

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
      a.panel-block(@click="base.cc_time_limit_modal_show_and_broadcast") 当事者は自分で発動＆BC
      a.panel-block(@click="base.cc_delayed_time_limit_modal") 他者は数秒後発動
      a.panel-block(@click="base.time_limit_modal_handle_if_not_exist") 受信
      a.panel-block(@click="base.cc_auto_time_limit_delay_stop") 数秒後発動キャンセル
      a.panel-block(@click="base.time_limit_modal_handle('self_notification')") モーダル(自首)
      a.panel-block(@click="base.time_limit_modal_handle('audo_judgement')") モーダル(判定)
      a.panel-block(@click="base.time_limit_modal_close") 閉じる
  .column.is-2
    .panel
      .panel-heading
        | その他
      a.panel-block(@click="base.handle_name_modal_handle") ハンドルネーム入力
      a.panel-block(@click="base.handle_name_alert") 順番設定中のハンドルネーム入力
      a.panel-block(@click="base.handle_name_clear_handle") ハンドルネームを空にする
      a.panel-block(@click="base.edit_warn_modal_handle") 編集警告
      a.panel-block(@click="base.al_add_test") 指し手
      a.panel-block(@click="base.clock_box_share({behaviour: '時計同期手動実行'})") 時計同期
      a.panel-block(@click="base.reload_modal_handle") リロード確認
      a.panel-block(@click="base.room_entry_call({from_user_name: 'alice'})") 入室コール
      a.panel-block(@click="base.room_leave_call({from_user_name: 'alice'})") 退室コール
      a.panel-block(@click="base.exit_confirm_then()") 退室確認
      a.panel-block(@click="base.os_modal_close_confirm()") 順番設定を保存せずに閉じた警告モーダル
      a.panel-block(@click="base.cc_play_confirm()") 順番設定OFFのまま時計開始警告モーダル
      a.panel-block(@click="base.cc_next_message") 順番設定後に時計設置を促す

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
    .panel#assert_system_variable
      .panel-heading
        | [assert_system_variable]
      .panel-block(v-if="base.order_enable_p && base.omembers_present_p")
        | 順序:
        template(v-for="(_, i) in 11")
          | {{base.ordered_member_by_turn(i).user_name[0]}}
      .panel-block tn_counter:{{base.tn_counter}}
      .panel-block current_turn:{{base.current_turn}}
      .panel-block order_enable_p:{{base.order_enable_p}}
      .panel-block clock_box:{{!!base.clock_box}}
      .panel-block clock_box.current_status:{{base.clock_box ? base.clock_box.current_status : ''}}
      .panel-block current_title:{{base.current_title}}
      .panel-block cc_params:{{base.cc_params_inspect(base.cc_params)}}
      .panel-block next_turn_message:{{base.next_turn_message}}
      .panel-block latest_foul_name:{{base.latest_foul_name}}

  .column.is-6.is-clipped
    .panel
      .panel-heading
        | TrackLog
      .panel-block
        ShareBoardTrackLog(:base="base")
  .column.is-12
    .panel
      .panel-heading
        | 絵文字
      .panel-block.is-block
        template(v-for="(e, i) in base.guardian_list")
          span.mx-1(v-xemoji) {{i}}:{{e}}
  .column.is-3
    .panel
      .panel-heading
        | click
      .panel-block
        b-button(@click="func1") 連打

//- DebugPre(v-if="development_p") {{$data}}
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

// import { Howl, Howler } from "howler"

export default {
  name: "ShareBoardDebugPanels",
  mixins: [support_child],

  methods: {
    func1() {
      this.func2()
    },
    func2: _.debounce(function() {
      this.func3()
    }, 1000),
    func3() {
      this.debug_alert("click2")
    },
  },

  computed: {
    Howler() { return Howler },
  },

}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardDebugPanels
  .xemoji
    height: 4rem
    width: unset
  .panel
    background-color: $white
</style>
