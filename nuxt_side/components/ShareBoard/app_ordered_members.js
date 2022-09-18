import OrderSettingModal from "./OrderSettingModal.vue"
import { OsChange } from "./models/os_change.js"
import { MoveGuardInfo } from "@/components/models/move_guard_info.js"
import { ShoutModeInfo } from "@/components/models/shout_mode_info.js"
import { TegotoInfo } from "@/components/models/tegoto_info.js"
import { FoulBehaviorInfo } from "@/components/models/foul_behavior_info.js"
import { OrderUnit } from "./models/order_unit/order_unit.js"
import _ from "lodash"
const PAIR = 2

export const app_ordered_members = {
  data() {
    return {
      // 共有する変数
      order_enable_p: false, // 順番設定 true:有効 false:無効 モーダル内では元変数を直接変更している
      order_unit: null,      // 出走順の実配列
      kaisi: 0,              // 駒落ちなら 1 にする

      // move_guard_key: "is_move_guard_on", // 手番制限

      // ローカルのモーダルで使うテンポラリ変数
      // 「適用」してはじめて実変数に反映する
      new_order_unit:         null, // テーブル用(出走順の実配列にあとから参加した人や観戦の人を追加したテンポラリ)
      new_move_guard_key:    null, // 手番制限
      new_avatar_king_key:   null, // アバター表示
      new_shout_mode_key:    null, // 叫びモード
      new_foul_behavior_key: null, // 反則をどうするか
      new_tegoto:            null, // N手毎交代

      os_change: null, // OsChange のインスタンス
    }
  },

  created() {
    this.os_setup_by_url_params()
  },

  methods: {
    // alice bob carol dave の順番で設定する場合は
    // fixed_order_names=alice,bob,carol,dave とする
    // fixed_order_names= なら空で設定
    os_setup_by_url_params() {
      if ("fixed_order_names" in this.$route.query) {
        const names = this.str_to_words(this.$route.query["fixed_order_names"])
        this.os_setup_by_names(names)
      }
    },

    os_setup_by_names(names) {
      const users = names.map((e, i) => ({
        user_name: e,
        enabled_p: true,
        order_index: i,
      }))
      this.order_unit = OrderUnit.create(users)

      this.order_enable_p = true  // 有効化
    },

    // 順番設定モーダル起動
    os_modal_handle() {
      if (this.if_room_is_empty()) { return }
      this.sidebar_p = false
      this.sound_play_click()
      this.__assert__(this.$os_modal_instance == null, "this.$os_modal_instance == null")
      this.$os_modal_instance = this.modal_card_open({
        component: OrderSettingModal,
        props: { base: this.base },
        canCancel: [],
        onCancel: () => {
          this.__assert__(false, "must not happen")
          this.sound_play_click()
          this.os_modal_close()
        },
      })
    },

    // 順番設定モーダルを閉じる
    // 別のところから強制的に閉じたいとき用
    os_modal_close() {
      if (this.$os_modal_instance) {
        this.$os_modal_instance.close()
        this.$os_modal_instance = null
        this.tl_alert("this.$os_modal_instance = null")
      }
    },

    os_modal_close_confirm(params = {}) {
      this.sound_play_click()
      this.talk("ちょっと待って。変更を適用せずに閉じようとしています")
      this.dialog_confirm({
        title: "ちょっと待って",
        type: "is-warning",
        hasIcon: true,
        message: this.os_change ? this.os_change.message : "(os_change undefined)",
        confirmText: "更新せずに閉じる",
        focusOn: "cancel",
        ...params,
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 順番設定モーダル内で使うデータの準備
    os_modal_vars_setup() {
      this.tl_alert("os_modal_vars_setup")

      this.new_order_unit_setup()

      this.new_move_guard_key    = this.move_guard_key
      this.new_avatar_king_key   = this.avatar_king_key
      this.new_shout_mode_key    = this.shout_mode_key
      this.new_foul_behavior_key = this.foul_behavior_key
      this.new_tegoto            = this.tegoto

      this.os_change = new OsChange()
    },

    new_order_unit_setup() {
      if (this.order_unit == null) {
        // 最初は全員を「参加」状態で入れる
        this.new_order_unit = OrderUnit.create(_.cloneDeep(this.os_table_rows_default))
      } else {
        // 1度自分で設定または他者から共有されている ordered_members を使う
        this.new_order_unit = this.order_unit.clone()

        // しかし、あとから接続して来た人たちが含まれていないため「観戦」状態で追加する
        if (true) {
          this.os_table_rows_default.forEach(m => {
            if (!this.new_order_unit.member_other.some(e => e.user_name === m.user_name)) {
              this.new_order_unit.member_other.push({
                user_name: m.user_name,
                order_index: null,  // 順番なし
                enabled_p: false,   // 観戦
              })
            }
          })
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 手数からメンバーを取得
    ordered_member_by_turn(turn) {
      if (this.order_disable_p) {
        // これがないと順番設定を無効にしても ordered_members が生きていると通知されてしまう
        return null
      }
      if (this.omembers_blank_p) {
        return null
      }
      return this.order_unit.current_user_by_turn(turn, this.tegoto, this.kaisi)
    },

    // 局面 turn の手番のメンバーの名前
    user_name_by_turn(turn) {
      const e = this.ordered_member_by_turn(turn)
      if (e) {
        return e.user_name
      }
    },
    // 局面 turn の手番の順番 ← なくてもいい？
    order_index_by_turn(turn) {
      const e = this.ordered_member_by_turn(turn)
      if (e) {
        return e.order_index
      }
    },

    // 指定の名前の人の順序
    order_index_by_user_name(user_name) {
      // これがないと順番設定を無効にしても ordered_members が生きていると通知されてしまう
      if (this.order_disable_p) {
        return null
      }
      if (this.omembers_blank_p) {
        return null
      }
      const e = this.order_unit.real_order_users(this.tegoto, this.kaisi).find(e => e.user_name === user_name)
      if (e) {
        if (e.enabled_p) {
          return e.order_index
        } else {
          // 観戦中
        }
      }
    },

    // 指定の名前の人の location
    location_by_name(name) {
      const index = this.order_index_by_user_name(name) // 順番設定から自分の番号(0..)を取得
      if (this.present_p(index)) {
        // this.tl_add("順番番号", index)
        // this.__assert__(this.present_p(index), "this.present_p(index)")
        const location = this.current_sfen_info.location_by_offset(index) // その番号を手番すると自分の最初の場所がわかる
        // this.tl_add("場所確定", location.key)
        return location
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 順番設定を無効化する
    order_switch_off_share() {
      this.order_switch_share({order_enable_p: false, message: "無効", toast_only: true})
    },
    order_switch_share(params) {
      params = {
        toast_only: false,
        ...params,
      }
      this.ac_room_perform("order_switch_share", params) // --> app/channels/share_board/room_channel.rb
    },
    order_switch_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.tl_alert("order_switch_share 自分→自分")
      } else {
        this.tl_alert("order_switch_share 自分→他者")
      }
      this.order_enable_p = params.order_enable_p
      if (this.order_disable_p) {
        this.message_scope_key = "is_message_scope_public"
      }
      if (params.message) {
        const message = `${this.user_call_name(params.from_user_name)}が順番設定を${params.message}にしました`
        this.toast_ok(message, {toast_only: params.toast_only})
      }
      if (this.present_p(params.message)) {
        this.al_add({
          ...params,
          label: "順番 " + (params.order_enable_p ? "ON" : "OFF"),
          sfen: this.current_sfen,
          turn: this.current_turn,
        })
      }
      this.ac_log("順設受信", `順番${this.order_enable_p ? "ON" : "OFF"}を受信`)
    },

    ////////////////////////////////////////////////////////////////////////////////

    any_order_share(params) {
      this.ac_room_perform("any_order_share", params) // --> app/channels/share_board/room_channel.rb
    },
    any_order_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.tl_alert("any_order_share 自分→自分")
      } else {
        this.tl_alert("any_order_share 自分→他者")
        if (false) {
          this.os_modal_close() // もし他者が順番設定モーダルを開いていたら閉じる
        }
      }

      this.om_vars_copy_from(params)

      // 順番設定モーダルを開いているかどうかに関係なくモーダルで使う変数を更新する
      // これは「自分→自身」でも動くので「観戦」状態の人が一番下に移動する
      if (true) {
        this.os_modal_vars_setup()
      }

      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が順番設定を${params.message}しました`)
      }

      if (this.present_p(params.message)) {
        this.al_add({
          ...params,
          label: "順番更新",
          sfen: this.current_sfen,
          turn: this.current_turn,
        })
      }
    },

    // 後から参加したときリクエストに答えてパラメータを送ってくれた人から受信した内容を反映する
    receive_xorder(params) {
      this.__assert__(this.present_p(params), "this.present_p(params)")
      this.__assert__("order_enable_p" in params, '"order_enable_p" in params')
      this.__assert__("order_unit" in params, '"order_unit" in params')

      this.tl_alert("順番設定パラメータを先代から受信")

      this.order_enable_p = params.order_enable_p
      this.om_vars_copy_from(params)
    },
    om_vars_copy_from(params) {
      this.order_unit        = OrderUnit.from_attributes(params.order_unit)
      this.move_guard_key    = params.move_guard_key
      this.avatar_king_key   = params.avatar_king_key
      this.shout_mode_key    = params.shout_mode_key
      this.foul_behavior_key = params.foul_behavior_key
      this.tegoto            = params.tegoto
      this.kaisi             = params.kaisi

      this.ac_log("順情受信", `オーダー受信 ${this.ordered_member_names_oneline} (順番${this.order_enable_p ? "ON" : "OFF"})`)
    },

    // 自分の場所を調べて正面をその視点にする
    sp_viewpoint_set_by_self_location() {
      this.__assert__(this.user_name, "this.user_name")
      const location = this.location_by_name(this.user_name) // 自分の▲△
      if (location) {
        this.sp_viewpoint = location.key                     // その視点に変更する
      }
    },

    order_lookup(e) {
      return this.order_lookup_from_name(e.from_user_name)
    },

    // 表示用の手番の番号
    order_display_index(e) {
      const found = this.order_lookup(e)
      if (found) {
        return found.order_index + 1
      }
    },

    order_lookup_from_name(name) {
      if (this.order_enable_p) {
        if (this.order_unit) {
          return this.omember_names_hash[name]
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // ShareBoardMemberList の1行のクラスに使っている
    member_info_class(e) {
      return {
        is_joined:       this.member_is_joined(e),       // 初期状態
        is_disconnect:   this.member_is_disconnect(e),   // 霊圧が消えかけ
        is_turn_active:  this.member_is_turn_active(e),  // 手番の人
        is_turn_standby: this.member_is_turn_standby(e), // 手番待ちの人
        is_watching:     this.member_is_watching(e),     // 観戦
        is_self:         this.member_is_self(e),         // 自分？
        is_window_blur:  this.member_is_window_blur(e),  // Windowが非アクティブ状態か？
      }
    },
    member_is_joined(e)       { return this.order_disable_p                                                     }, // 初期状態
    member_is_turn_active(e)  { return this.order_lookup(e) && this.current_turn_user_name === e.from_user_name }, // 手番の人
    member_is_turn_standby(e) { return this.order_lookup(e) && this.current_turn_user_name !== e.from_user_name }, // 手番待ちの人
    member_is_watching(e)     { return this.order_enable_p && !this.order_lookup(e)                               }, // 観戦
    member_is_self(e)         { return this.connection_id === e.from_connection_id                              }, // 自分

    // Windowが非アクティブ状態か？
    member_is_window_blur(e)  {
      if (this.$route.query.member_is_window_blur === "true") {
        return true
      }
      return !e.window_active_p
    },

    member_status_label(e) {
      if (this.member_is_turn_active(e)) {
        return "手番"
      }
      if (this.member_is_turn_standby(e)) {
        return "手番待ち"
      }
      if (this.member_is_watching(e)) {
        return "観戦中"
      }
      return "不明"
    },
    ////////////////////////////////////////////////////////////////////////////////
  },

  computed: {
    MoveGuardInfo()   { return MoveGuardInfo                                 },
    move_guard_info() { return this.MoveGuardInfo.fetch(this.move_guard_key) },

    ShoutModeInfo()   { return ShoutModeInfo                                 },
    shout_mode_info() { return this.ShoutModeInfo.fetch(this.shout_mode_key) },
    is_shout_mode_on() { return this.shout_mode_info.key === "is_shout_mode_on" },

    FoulBehaviorInfo()     { return FoulBehaviorInfo                                 },
    foul_behavior_info()   { return this.FoulBehaviorInfo.fetch(this.foul_behavior_key) },

    TegotoInfo()   { return TegotoInfo                                 },

    // あとから接続した人に伝える内容
    current_xorder() {
      return {
        order_enable_p:  this.order_enable_p,
        order_unit:      this.order_unit ? this.order_unit.attributes : null,
        move_guard_key:  this.move_guard_key,
        avatar_king_key: this.avatar_king_key,
        shout_mode_key:  this.shout_mode_key,
        foul_behavior_key: this.foul_behavior_key,
        tegoto:    this.tegoto,
        kaisi:    this.kaisi,

        __nil_check_skip_keys__: "order_unit", // 最初の状態で ordered_members は null なので nil チェックにひっかかる
      }
    },

    // モーダル用の new_order_unit の初期値
    os_table_rows_default() {
      return this.name_uniq_member_infos.map((e, i) => {
        return {
          enabled_p: true,
          order_index: i,
          user_name: e.from_user_name,
        }
      })
      return v
    },

    // 順番設定ダイアログ内での、参加者だけの配列
    new_order_unit() {
      return this.new_order_unit.filter(e => e.enabled_p)
    },

    // 順番設定ダイアログ内での、参加者数は奇数か？
    // new_order_unit_odd_p() {
    //   return this.odd_p(this.new_order_unit.length)
    // },

    // 手番制限
    // 条件 機能ON
    // 条件 共有中のとき
    // 条件 メンバーリストが揃っている
    // 条件 手番制限ON
    // 条件 自分の手番はないとき
    sp_human_side() {
      let retv = "both"
      if (this.order_enable_p) {
        if (this.ac_room) {
          // メンバーリストが揃っているなら
          // if (this.omembers_blank_p) {
          if (this.move_guard_info.key === "is_move_guard_on") {
            // 手番制限なら観戦者含めて全体を「禁止」にする
            retv = "none"
            if (this.current_turn_self_p) {
              // そのあとで対象者だけを指せるようにする
              retv = "both"
            }
          }
        }
      }
      return retv
    },

    order_disable_p() { return !this.order_enable_p }, // 順番設定OFF？

    self_vs_self_p() { return this.order_enable_p && this.order_unit && this.order_unit.self_vs_self_p }, // 自分vs自分で対戦している？
    one_vs_one_p()   { return this.order_enable_p && this.order_unit && this.order_unit.one_vs_one_p   }, // 1vs1で対戦している？
    many_vs_many_p() { return this.order_enable_p && this.order_unit && this.order_unit.many_vs_many_p }, // 3人以上で対戦している？

    watching_member_count() { return this.name_uniq_member_infos.filter(e => this.member_is_watching(e)).length }, // 観戦者数

    // private
    omembers_blank_p()   { return this.order_unit == null || this.order_unit.user_total_count === 0 }, // メンバーリストが空？
    omembers_present_p() { return this.order_unit && this.order_unit.user_total_count > 0           }, // メンバーリストがある？
    current_turn_user_name()    { return this.user_name_by_turn(this.current_turn)       }, // 今の局面のメンバーの名前
    current_turn_self_p()       { return this.current_turn_user_name === this.user_name  }, // 今は自分の手番か？
    next_turn_user_name()       { return this.user_name_by_turn(this.current_turn + 1)   }, // 次の局面のメンバーの名前
    next_turn_self_p()          { return this.next_turn_user_name === this.user_name     }, // 次は自分の手番か？
    previous_turn_user_name()   { return this.user_name_by_turn(this.current_turn - 1)   }, // 前の局面のメンバーの名前
    previous_turn_self_p()      { return this.previous_turn_user_name === this.user_name }, // 前は自分の手番か？
    self_is_member_p()          { return !!this.order_lookup_from_name(this.user_name)   }, // 自分はメンバーに含まれているか？
    self_is_watcher_p()         { return !this.self_is_member_p                          }, // 自分は観戦者か？

    ordered_member_names_oneline() {
      if (this.order_unit) {
        return this.order_unit.real_order_users(this.tegoto, this.kaisi).map(e => e.user_name).join("→")
      }
    }, // 順序(デバッグ用)

    // 名前から順番を知るためのハッシュ
    omember_names_hash() {
      if (this.order_unit) {
        return this.order_unit.omember_names_hash(this.kaisi)
      }
    },

    // 変更したけど保存せずにモーダルを閉じようとしている？
    os_modal_close_if_not_save_p() {
      return this.order_enable_p && this.os_change.has_value_p
    },

    // 最終的に左側に表示する並びになっているメンバーリスト
    // 順番設定されているときは対局者を優先的に上に表示する
    visible_member_infos() {
      if (this.order_enable_p) {
        if (this.order_unit) {
          return _.sortBy(this.member_infos, e => this.omember_names_hash[e.from_user_name] ?? this.member_infos.length)
        }
      }
      return this.member_infos
    },
  },
}
