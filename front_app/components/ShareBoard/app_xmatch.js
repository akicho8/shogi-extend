import _ from "lodash"
import XmatchModal from "./XmatchModal.vue"
import { XmatchRuleInfo } from "@/components/models/xmatch_rule_info.js"
import { IntervalCounter } from '@/components/models/interval_counter.js'

const WAIT_TIME_MAX           = 60 * 2      // 待ち時間最大
const XMATCH_REDIS_TTL        = 60 * 2 + 3  // redis.hset する度に更新するTTL
const UNSELECT_IF_WINDOW_BLUR = false       // ウィンドウを離れたときマッチングをキャンセルするか？
const START_TOAST_DELAY       = 3           // 誰々から開始してくださいをN秒後に発動する

export const app_xmatch = {
  data() {
    return {
      ac_lobby: null,              // subscriptions.create のインスタンス
      xmatch_rules_members: null,     // XmatchModal で表示していている内容
      xmatch_modal_instance: null, // XmatchModal のインスタンス
      current_xmatch_rule_key: null,  // 現在選択しているルール
      xmatch_interval_counter: new IntervalCounter(this.xmatch_interval_counter_callback),
    }
  },
  beforeDestroy() {
    this.lobby_destroy()
  },
  methods: {
    // 自動で開始する方法確認
    // http://0.0.0.0:4000/share-board?autoexec=test_direct1
    test_direct1() {
      this.room_code = "__room_code__"
      this.user_name = "x"

      this.os_setup_by_names(["alice"])

      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
      this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
    },

    // 自動マッチングモーダル起動
    xmatch_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      if (this.development_p) {
        // ログイン不要
      } else {
        if (this.sns_login_required()) {
          return
        }
      }

      this.room_destroy()

      this.xmatch_modal_close()
      this.xmatch_modal_instance = this.$buefy.modal.open({
        component: XmatchModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => { this.sound_play("click") },
        props: { base: this.base },
      })
    },

    // 自動マッチングモーダルを外部から閉じる
    xmatch_modal_close() {
      if (this.xmatch_modal_instance) {
        this.xmatch_modal_instance.close()
        this.xmatch_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    lobby_create() {
      this.__assert__(this.user_name, "this.user_name")
      this.__assert__(this.ac_lobby == null, "this.ac_lobby == null")

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
      params = {
        from_connection_id: this.connection_id,      // 送信者識別子
        from_user_name:     this.user_name,          // 送信者名
        performed_at:       this.time_current_ms(),  // 実行日時(ms)
        ua_icon:            this.ua_icon,            // 端末の種類を表すアイコン文字列
        current_user_id:    this.g_current_user?.id, // こっちをRedisのキーにしたかったがsystemテストが書けないため断念
        ...params,
      }
      if (this.ac_lobby) {
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
        this.debug_alert("他者がエントリー")
        // this.sound_play("click")
      }

      this.xmatch_rules_members = params.xmatch_rules_members // マッチング画面の情報
      this.sound_play_random(["dog1", "dog2", "dog3"])
      this.vibrate(200)
      this.delay_block(0.5, () => this.toast_ok(`${this.user_call_name(params.from_user_name)}がエントリーしました`))
      // this.sound_play("click")

      // 合言葉がある場合マッチングが成立している
      if (params.room_code) {
        this.__assert__(params.members, "params.members")
        if (params.members.some(e => e.from_connection_id === this.connection_id)) { // 自分が含まれていれば

          this.xmatch_rule_key_reset()

          if (this.development_p) {
          } else {
            this.xmatch_modal_close()
          }
          this.xmatch_setup1_member(params)   // 順番設定(必ず最初)
          this.xmatch_setup2_handicap(params) // 手合割
          this.xmatch_setup3_clock(params)    // チェスクロック
          this.xmatch_setup4_join(params)     // 部屋に入る
          this.xmatch_setup5_call(params)     // 「開始してください」コール
        }
      }
    },
    // 順番設定
    xmatch_setup1_member(params) {
      const names = params.members.map(e => e.from_user_name)
      this.os_setup_by_names(names)
      this.tl_add("順番設定", names, this.ordered_members)
    },
    // 手合割と視点設定
    xmatch_setup2_handicap(params) {
      const xmatch_rule_info = XmatchRuleInfo.fetch(params.xmatch_rule_key)

      this.turn_offset = 0                                              // 手数0から始める
      this.current_sfen = xmatch_rule_info.handicap_preset_info.sfen       // 手合割の反映
      this.sp_viewpoint_set_by_self_location()                                           // 自分の場所を調べて正面をその視点にする
    },
    xmatch_setup3_clock(params) {
      const xmatch_rule_info = XmatchRuleInfo.fetch(params.xmatch_rule_key)
      this.cc_params = {...xmatch_rule_info.cc_params} // チェスクロック時間設定
      this.cc_create()                              // チェスクロック起動 (先後は current_location.code で決める)
      this.cc_params_apply()                        // チェスクロックに時間設定を適用
      this.clock_box.play_handle()                  // PLAY押す
    },
    xmatch_setup4_join(params) {
      // 各クライアントで順番と時計が設定されている状態でさらに部屋共有による情報選抜が起きる
      // めちゃくちゃだけどホストの概念がないのでこれでいい
      this.room_destroy()               // デバッグ時にダイアログの選択肢再選択も耐えるため
      this.room_code = params.room_code // サーバー側で決めた共通の合言葉を使う
      this.room_create()
    },
    xmatch_setup5_call() {
      this.delay_block(START_TOAST_DELAY, () => {
        this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
      })
    },

    //////////////////////////////////////////////////////////////////////////////// 選択解除の同期

    rule_unselect() {
      this.xmatch_interval_counter.stop() // 自分側だけの問題なので早めに停止しておく
      this.ac_lobby_perform("rule_unselect", {
      }) // --> app/channels/share_board/lobby_channel.rb
    },

    rule_unselect_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分
        this.xmatch_rule_key_reset()
      } else {
        // 他の人から自分
        this.sound_play("click")
        this.debug_alert("他者がエントリー解除")
        this.delay_block(0, () => this.toast_ok(`${this.user_call_name(params.from_user_name)}が去りました`))
      }
      this.xmatch_rules_members = params.xmatch_rules_members // マッチング画面の情報
    },

    ////////////////////////////////////////////////////////////////////////////////

    // ウィンドウを離れたらエントリー解除する
    xmatch_window_blur() {
      if (this.ac_lobby) {
        if (this.current_xmatch_rule_key) {
          if (UNSELECT_IF_WINDOW_BLUR) {
            this.sound_play("click")
            this.toast_ok("他の所に行ったので選択を解除しました")
            this.rule_unselect()
          }
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    xmatch_interval_counter_callback() {
      if (this.xmatch_rest_seconds <= 1) { // カウンタをインクリメントする直前でコールバックしているため0じゃなくて1
        this.sound_play("x")
        this.rule_unselect()
        this.toast_ok("時間内に集まりませんでした")
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
      this.xmatch_interval_counter.counter = this.wait_time_max - n
    },
  },
  computed: {
    XmatchRuleInfo() { return XmatchRuleInfo },

    wait_time_max()    { return parseInt(this.$route.query.wait_time_max || WAIT_TIME_MAX)       },
    xmatch_redis_ttl() { return parseInt(this.$route.query.xmatch_redis_ttl || XMATCH_REDIS_TTL) },

    xmatch_rest_seconds() {
      return this.wait_time_max - this.xmatch_interval_counter.counter
    },
  },
}
