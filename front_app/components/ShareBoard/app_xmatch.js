import _ from "lodash"
import XmatchModal from "./XmatchModal.vue"
import { SbxRuleInfo } from "@/components/models/sbx_rule_info.js"

const START_TOAST_DELAY = 3

export const app_xmatch = {
  data() {
    return {
      ac_lobby: null,           // subscriptions.create のインスタンス
      sbx_rules_members: {},
      xmatch_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.lobby_destroy()
  },
  methods: {
    test_direct1() {
      this.room_code = "__room_code__"
      this.user_name

      this.os_setup_by_names(["alice"])

      // this.cc_params

      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
      this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
    },

    xmatch_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      if (this.sns_login_required()) {
        return
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
    xmatch_modal_close() {
      if (this.xmatch_modal_instance) {
        this.xmatch_modal_instance.close()
        this.xmatch_modal_instance = null
      }
    },

    lobby_create() {
      this.__assert__(this.user_name, "this.user_name")
      this.__assert__(this.ac_lobby == null, "this.ac_lobby == null")

      this.tl_add("SBX", `subscriptions.create`)
      this.ac_lobby = this.ac_subscription_create({channel: "ShareBoard::LobbyChannel"}, {
        initialized: e => {
          this.tl_add("SBX", "initialized", e)
        },
        connected: e => {
          this.tl_add("SBX", "connected", e)
        },
        disconnected: e => {
          this.tl_add("SBX", "disconnected", e)
        },
        rejected: e => {
          this.tl_add("SBX", "rejected", e)
        },
        received: e => {
          this.tl_add("SBX", `received: ${e.bc_action}`, e)
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
        from_connection_id: this.connection_id,     // 送信者識別子
        from_user_name:     this.user_name,         // 送信者名
        performed_at:       this.time_current_ms(), // 実行日時(ms)
        // active_level:       this.active_level,      // 先輩度(高い方が信憑性のある情報)
        ua_icon:            this.ua_icon,           // 端末の種類を表すアイコン文字列
        current_user_id:    this.g_current_user.id,
        ...params,
      }
      if (this.ac_lobby) {
        this.ac_lobby.perform(action, params) // --> app/channels/share_board/lobby_channel.rb
        this.tl_add("LOBBY", `perform ${action}`, params)
      }
    },

    subscribed_broadcasted(params) {
      this.sbx_rules_members = params.sbx_rules_members
    },

    // //////////////////////////////////////////////////////////////////////////////// 退室
    rule_select(e) {
      this.ac_lobby_perform("rule_select", {
        sbx_rule_key: e.key,
      }) // --> app/channels/share_board/lobby_channel.rb
    },
    rule_select_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分
      } else {
        // 自分から他の人
      }

      // マッチング画面の情報
      this.sbx_rules_members = params.sbx_rules_members

      // 合言葉がある場合マッチングが成立している
      if (params.room_code) {
        this.__assert__(params.members, "params.members")
        if (params.members.some(e => e.from_connection_id === this.connection_id)) { // 自分が含まれていれば
          if (this.development_p) {
          } else {
            this.xmatch_modal_close()
          }
          this.xmatch_setup1(params) // 順番設定(必ず最初)
          this.xmatch_setup2(params) // 手合割
          this.xmatch_setup3(params) // チェスクロック
          this.xmatch_setup4(params) // 部屋に入る
          this.xmatch_setup5(params) // 「開始してください」コール
        }
      }
    },
    // 順番設定
    xmatch_setup1(params) {
      const names = params.members.map(e => e.from_user_name)
      this.os_setup_by_names(names)
      this.tl_add("順番設定", names, this.ordered_members)
    },
    // 手合割と視点設定
    xmatch_setup2(params) {
      const sbx_rule_info = SbxRuleInfo.fetch(params.sbx_rule_key)

      this.turn_offset = 0                                              // 手数0から始める
      this.current_sfen = sbx_rule_info.handicap_preset_info.sfen       // 手合割の反映
      this.sp_viewpoint_set_by_self_location()                                           // 自分の場所を調べて正面をその視点にする
    },
    xmatch_setup3(params) {
      const sbx_rule_info = SbxRuleInfo.fetch(params.sbx_rule_key)
      this.cc_params = {...sbx_rule_info.cc_params} // チェスクロック時間設定
      this.cc_create()                              // チェスクロック起動 (先後は current_location.code で決める)
      this.cc_params_apply()                        // チェスクロックに時間設定を適用
      this.clock_box.play_handle()                  // PLAY押す
    },
    xmatch_setup4(params) {
      // 各クライアントで順番と時計が設定されている状態でさらに部屋共有による情報選抜が起きる
      // めちゃくちゃだけどホストの概念がないのでこれでいい
      this.room_destroy()               // デバッグ時にダイアログの選択肢再選択も耐えるため
      this.room_code = params.room_code // サーバー側で決めた共通の合言葉を使う
      this.room_create()
    },
    xmatch_setup5() {
      this.delay_block(START_TOAST_DELAY, () => {
        this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
      })
    },
  },
  computed: {
    SbxRuleInfo() { return SbxRuleInfo },
  },
}
