import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import XmatchModal from "./XmatchModal.vue"
import { XmatchRuleInfo } from "@/components/models/xmatch_rule_info.js"
import { XmatchAuthInfo } from "@/components/models/xmatch_auth_info.js"
import { IntervalCounter } from '@/components/models/interval_counter.js'

const START_TOAST_DELAY = 3                // 誰々から開始してくださいをN秒後に発動する
const UNSELECT_IF_WINDOW_BLUR = true       // ウィンドウを離れたときマッチングをキャンセルするか？

export const mod_xmatch = {
  data() {
    return {
      ac_lobby: null,                // subscriptions.create のインスタンス
      xmatch_rules_members: null,    // XmatchModal で表示していている内容
      xmatch_modal_instance: null,   // XmatchModal のインスタンス
      current_xmatch_rule_key: null, // 現在選択しているルール
      xmatch_interval_counter: new IntervalCounter(this.xmatch_interval_counter_callback),
    }
  },

  beforeDestroy() {
    this.lobby_destroy()
  },

  methods: {
    // 自動で開始する方法確認
    // http://localhost:4000/share-board?autoexec=test_direct1
    test_direct1() {
      this.room_key = "__room_key__"
      this.user_name = "x"

      this.os_setup_by_names(["alice"])

      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
      this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
    },

    // 自動マッチングモーダル起動(ショートカット)
    // http://localhost:4000/share-board?autoexec=vs
    vs() {
      this.xmatch_modal_core()
    },

    // 自動マッチングモーダル起動
    xmatch_modal_handle() {
      this.sidebar_p = false
      this.sfx_click()
      this.xmatch_modal_core()
    },

    // 自動マッチングモーダル起動 (vsから呼ぶ用)
    xmatch_modal_core() {
      // 部屋で相談している途中からもしれないので退室してはいけない
      if (false) {
        this.room_destroy()
      }

      // 初期化処理 XmatchModal の mounted などで呼ぶと開発時の hot reload 何回も呼ばれるので扱いづらくなる
      if (true) {
        this.xmatch_rules_members = null // 前の状態が出てしまわないように初期化しておく
        this.lobby_create()              // ac_lobby を作る
      }

      // https://buefy.org/documentation/modal/
      this.xmatch_modal_close()
      this.xmatch_modal_instance = this.modal_card_open({
        component: XmatchModal,
        onCancel: () => {
          this.sfx_click()
          this.xmatch_rule_key_reset() // ac_lobbyが閉じているBCが来ないかもしれないため最初に解除しておく
          this.SB.rule_unselect("${name}がやめました")
          this.xmatch_modal_close()
        },
      })
    },

    // 自動マッチングモーダルを外部から閉じる
    xmatch_modal_close() {
      if (this.xmatch_modal_instance) {
        this.xmatch_modal_instance.close()
        this.xmatch_modal_instance = null
      }
    },

    //////////////////////////////////////////////////////////////////////////////// ActionCable

    lobby_create() {
      // GX.assert(this.user_name, "this.user_name")
      GX.assert(this.ac_lobby == null, "this.ac_lobby == null")

      this.tl_add("XMATCH", `subscriptions.create`)
      this.ac_lobby = this.ac_subscription_create({channel: "ShareBoard::LobbyChannel"}, {
        all_hook: (method, e) => {
          if (method !== "received") {
            this.tl_add("XMATCH", method, e)
          }
        },
        received: e => {
          this.tl_add("XMATCH", `received: ${e.bc_action}`, e)
          this.api_version_valid(e.bc_params.API_VERSION)
        },
      })
    },

    lobby_destroy() {
      if (this.ac_lobby) {
        this.ac_unsubscribe("ac_lobby")
      }
    },

    // perform のラッパーで共通のパラメータを入れる
    ac_lobby_perform(action, params = {}) {
      if (this.ac_lobby) {
        // GX.assert(this.g_current_user, "this.g_current_user")
        params = {
          from_connection_id: this.connection_id,      // 送信者識別子
          from_user_name:     this.user_name,          // 送信者名
          performed_at:       this.$time.current_ms(),  // 実行日時(ms)
          ua_icon_key:            this.ua_icon_key,            // 端末の種類を表すアイコン文字列
          ...params,
        }
        // これ不要。こっちをRedisのキーにしたかったがsystemテストが書けないため断念
        if (this.g_current_user) {
          params.current_user_id = this.g_current_user.id
        }
        this.ac_lobby.perform(action, params) // --> app/channels/share_board/lobby_channel.rb
        this.tl_add("LOBBY", `perform ${action}`, params)
      }
    },

    // subscribe したタイミングで来る
    subscribed_broadcasted(params) {
      this.xmatch_rules_members = params.xmatch_rules_members
    },

    //////////////////////////////////////////////////////////////////////////////// ルール選択
    rule_select(e) {
      GX.assert(GX.present_p(this.user_name), "GX.present_p(this.user_name)")

      this.ac_lobby_perform("rule_select", {
        xmatch_rule_key: e.key,                     // 選択したルール
        xmatch_redis_ttl: this.xmatch_redis_ttl, // JS側で一括管理したいのでこちらからTTLを渡す
      }) // --> app/channels/share_board/lobby_channel.rb

    },
    rule_select_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分
        this.current_xmatch_rule_key = params.xmatch_rule_key
      } else {
        // 他の人から自分
        this.sfx_click()
        this.tl_alert("他者がエントリー")
        // this.sfx_click()
      }

      this.xmatch_rules_members = params.xmatch_rules_members // マッチング画面の情報
      // this.sfx_play_random(["dog1", "dog2", "dog3"])
      this.beat_call("middle")
      const xmatch_rule_info = XmatchRuleInfo.fetch(params.xmatch_rule_key)
      GX.delay_block(0, () => this.toast_ok(`${this.user_call_name(params.from_user_name)}が${xmatch_rule_info.name}にエントリーしました`))
      // this.sfx_click()
      // 合言葉がある場合マッチングが成立している
      if (params.room_key) {
        GX.assert(params.members, "params.members")
        if (params.members.some(e => e.from_connection_id === this.connection_id)) { // 自分が含まれていれば
          this.xmatch_establishment(params)
        }
      }
    },

    // マッチング成立
    xmatch_establishment(params) {
      this.xmatch_rule_key_reset()
      if (this.development_p) {
        this.debug_alert("production なら XmatchModal は閉じる")
      } else {
        this.xmatch_modal_close()
      }
      this.xmatch_setup1_member(params)   // 順番設定(必ず最初)
      this.xmatch_setup2_handicap(params) // 手合割
      this.xmatch_setup3_clock(params)    // チェスクロック
      this.xmatch_setup4_join(params)     // 入退室
      this.xmatch_setup5_call(params)     // 「開始してください」コール
      this.xmatch_setup6_title(params)    // タイトル変更
    },

    // 順番設定
    xmatch_setup1_member(params) {
      const names = params.members.map(e => e.from_user_name)
      this.os_setup_by_names(names)
      this.tl_add("順番設定", names, this.order_unit)
    },
    // 手合割と視点設定
    xmatch_setup2_handicap(params) {
      const xmatch_rule_info = XmatchRuleInfo.fetch(params.xmatch_rule_key)
      this.current_turn = 0                                           // 手数0から始める
      this.current_sfen = xmatch_rule_info.board_preset_info.sfen // 手合割の反映
      this.sp_viewpoint_set_by_self_location()                       // 自分の場所を調べて正面をその視点にする
    },
    xmatch_setup3_clock(params) {
      const xmatch_rule_info = XmatchRuleInfo.fetch(params.xmatch_rule_key)
      this.cc_params = xmatch_rule_info.cc_params        // チェスクロック時間設定
      this.cc_create()                                   // チェスクロック起動 (先後は current_location.code で決める)
      this.cc_params_apply()                             // チェスクロックに時間設定を適用
      this.clock_box.play_handle()                       // PLAY押す
    },
    xmatch_setup4_join(params) {
      // 各クライアントで順番と時計が設定されている状態でさらに部屋共有による情報選抜が起きる
      // めちゃくちゃだけどホストの概念がないのでこれでいい
      this.room_destroy()               // デバッグ時にダイアログの選択肢再選択も耐えるため
      this.room_key = params.room_key // サーバー側で決めた共通の合言葉を使う
      this.room_create()
    },
    xmatch_setup5_call(params) {
      GX.delay_block(START_TOAST_DELAY, () => {
        this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
      })
    },
    xmatch_setup6_title(params) {
      const xmatch_rule_info = XmatchRuleInfo.fetch(params.xmatch_rule_key)
      this.current_title = xmatch_rule_info.name
    },

    //////////////////////////////////////////////////////////////////////////////// 選択解除の同期

    rule_unselect(message = null) {
      const params = {}
      if (message) {
        params.message = message
      }
      this.xmatch_interval_counter.stop() // 自分側だけの問題なので早めに停止しておく
      this.ac_lobby_perform("rule_unselect", params) // --> app/channels/share_board/lobby_channel.rb
    },

    rule_unselect_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分
        this.xmatch_rule_key_reset()
      } else {
        // 他の人から自分
        this.tl_alert("他者がエントリー解除")
      }

      if (params.delete_result === "deleted") {
        if (params.message) {
          if (!this.received_from_self(params)) {
            this.sfx_click()
          }
          this.toast_ok(_.template(params.message)({name: this.user_call_name(params.from_user_name)}))
        } else {
          // 静かに処理
        }
      } else {
        this.tl_alert("エントリーしていないのに解除しようとした")
      }

      this.xmatch_rules_members = params.xmatch_rules_members // マッチング画面の情報
    },

    ////////////////////////////////////////////////////////////////////////////////

    // ウィンドウを離れたらエントリー解除する
    xmatch_window_blur() {
      if (UNSELECT_IF_WINDOW_BLUR) {
        if (this.ac_lobby) {
          if (this.current_xmatch_rule_key) {
            if (this.development_p) {
              this.tl_alert("他の所に行ったので解除しました")
            } else {
              this.rule_unselect("${name}がどっか行ったので解除しました")
            }
          }
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    xmatch_interval_counter_callback() {
      if (this.xmatch_rest_seconds <= 1) { // カウンタをインクリメントする直前でコールバックしているため0じゃなくて1
        this.sfx_play("x")
        this.rule_unselect("時間内に集まらなかったので${name}を解除しました")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 選択解除
    xmatch_rule_key_reset() {
      this.current_xmatch_rule_key = null // 基本モーダル内で使うだけなので対局開始と同時に選択していない状態にしておく
      this.xmatch_interval_counter.stop()
    },

    // 残りN秒にする
    xmatch_interval_counter_rest_n(n) {
      this.xmatch_interval_counter.counter = this.xmatch_wait_max - n
    },
  },
  computed: {
    XmatchRuleInfo()      { return XmatchRuleInfo                                              },
    xmatch_rest_seconds() { return this.xmatch_wait_max - this.xmatch_interval_counter.counter },

    XmatchAuthInfo()      { return XmatchAuthInfo                                              },
    xmatch_auth_info()    { return this.XmatchAuthInfo.fetch(this.xmatch_auth_key)             },
  },
}
