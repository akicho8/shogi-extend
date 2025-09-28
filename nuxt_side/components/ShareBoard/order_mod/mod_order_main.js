// 対局中に参照する順番設定

import { OrderUnit } from "./order_unit/order_unit.js"

import { mod_order_new    } from "./mod_order_new.js"
import { mod_order_turn   } from "./mod_order_turn.js"
import { mod_order_option } from "./mod_order_option.js"

import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export const mod_order_main = {
  mixins: [
    mod_order_new,
    mod_order_turn,
    mod_order_option,
  ],
  data() {
    return {
      order_unit: OrderUnit.create(), // 順番設定 情報 (nullかどうかの確認が大変すぎるため最初から入れておく)
    }
  },
  mounted() {
    this.os_setup()
  },
  methods: {
    os_setup() {
      // 引数があればその順番にする
      if (Gs.present_p(this.fixed_order_names)) {
        this.os_setup_by_names(Gs.str_to_words(this.fixed_order_names))
      }
      // 1列か2列かを確定する。初期値は2列
      this.order_unit.state_switch_to(this.fixed_order_state)

      // 自分の場所を調べて正面をその視点にする
      this.sp_viewpoint_set_by_self_location()
    },

    // 指定の名前
    os_setup_by_names(names) {
      this.order_unit = OrderUnit.create(names)
      this.order_enable_p = true
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 順番設定を無効化する
    order_switch_off_share() {
      this.order_switch_share({order_enable_p: false, message: "", talk: false})
    },
    order_switch_share(params) {
      this.ac_room_perform("order_switch_share", params) // --> app/channels/share_board/room_channel.rb
    },
    order_switch_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.tl_alert("order_switch_share 自分→自分")
      } else {
        this.tl_alert("order_switch_share 自分→他者")
      }
      this.order_enable_p = params.order_enable_p
      this.order_off_then_message_scope_key_set_public() // 順番設定OFFになったら自動的にチャットの送信先スコープを「全体宛」に戻す
      // this.think_mark_auto_set()                     // 順番設定反映後、自分の立場に応じてマークモードの初期値を自動で設定する

      // 順番設定ONのタイミングで本譜を消す
      // これは投了せずに対局を終了した人が前の対局の本譜を参照して混乱しているのを見かけたために入れてある
      if (this.order_enable_p) {
        this.honpu_all_clear()
      }

      if (params.message) {
        const message = `${this.user_call_name(params.from_user_name)}が順番設定を${params.message}にしました`
        this.toast_ok(message, {toast: true, talk: true, ...params})
      }
      if (Gs.present_p(params.message)) {
        this.al_add({...params, label: "順番 " + (params.order_enable_p ? "ON" : "OFF")})
      }
      this.ac_log({subject: "順設受信", body: `順番${this.order_enable_p ? "ON" : "OFF"}を受信`})
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 後から参加したときリクエストに答えてパラメータを送ってくれた人から受信した内容を反映する
    order_share_data_receive(params) {
      Gs.assert(Gs.present_p(params), "Gs.present_p(params)")
      Gs.assert("order_enable_p" in params, '"order_enable_p" in params')
      Gs.assert("order_unit" in params, '"order_unit" in params')

      this.tl_alert("順番設定パラメータを先代から受信")

      this.order_enable_p = params.order_enable_p
      this.order_off_then_message_scope_key_set_public() // 順番設定OFFになったら自動的にチャットの送信先スコープを「全体宛」に戻す
      this.order_copy_from_bc(params)
    },
    // 後から参加したとき、または順番設定を適用したときに呼ばれる
    order_copy_from_bc(params) {
      Gs.assert(params.order_unit, "params.order_unit")

      this.order_unit        = OrderUnit.from_attributes(params.order_unit)
      this.sp_viewpoint_set_by_self_location() // 自分の場所を調べて正面をその視点にする
      // this.think_mark_auto_set()                     // 順番設定反映後、自分の立場に応じてマークモードの初期値を自動で設定する

      this.os_options_copy_a_to_b(params, this)

      this.ac_log({subject: "順情受信", body: `オーダー受信 ${this.ordered_member_names_oneline} (順番${this.order_enable_p ? "ON" : "OFF"})`})
    },

    // 自分の場所を調べて正面をその視点にする
    sp_viewpoint_set_by_self_location() {
      if (this.user_name) {
        const location = this.user_name_to_initial_location(this.user_name) // 自分の▲△
        if (location) {
          this.viewpoint = location.key                     // その視点に変更する
        }
      }
    },

    // user_name に対応する対局者情報を返す
    // なければ対局者ではない
    order_lookup_from_name(user_name) {
      if (this.order_enable_p) {
        return this.order_unit.name_to_object_hash[user_name]
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // user_name は自分と同じチームか？
    user_name_is_same_team_p(user_name) {
      const location = this.user_name_to_initial_location(user_name)
      if (location && this.my_location) {
        return location.key === this.my_location.key
      }
    },

    // user_name は自分の対戦相手か？
    user_name_is_opponent_team_p(user_name) {
      const location = this.user_name_to_initial_location(user_name)
      if (location && this.my_location) {
        return location.key !== this.my_location.key
      }
    },

    // user_name は自分と同じ観戦者か？
    user_name_is_same_watcher_p(user_name) {
      const location = this.user_name_to_initial_location(user_name)
      return location == null && this.my_location == null
    }
  },

  computed: {
    // あとから接続した人に伝える内容
    order_share_data() {
      return {
        order_enable_p:    this.order_enable_p,
        order_unit:        this.order_unit ? this.order_unit.attributes : null,
        foul_mode_key: this.foul_mode_key,
        auto_resign_key: this.auto_resign_key,
        think_mark_receive_scope_key: this.think_mark_receive_scope_key,
        change_per:            this.change_per,
        __nil_check_skip_keys__: "order_unit", // 最初の状態で ordered_members は null なので nil チェックにひっかかる
      }
    },

    // 手番制限
    // 条件 順番設定ON
    // 条件 部屋が立っている
    // 条件 メンバーリストが揃っている
    // 条件 自分の手番はないとき
    sp_human_side() {
      // マークモードでは駒を動かせないようにする
      if (this.think_mark_mode_p) {
        return "none"
      }

      let retval = "both"                                          // デフォルトは誰でも動かせる
      if (this.order_enable_p) {                                 // 順番設定が有効かつ
        if (this.ac_room) {                                      // 部屋が立てられていて
          retval = "none"                                        // 観戦者含めて全体を「禁止」にする
          if (this.self_vs_self_p) {                           // 自分vs自分なら例外的に常時自分にする
            retval = "both"
          } else {
            if (this.current_turn_self_p) {                    // そのあとで対象者だけを
              retval = "both"                                    // 指せるようにする
            }
          }
        }
      }
      return retval
    },

    order_ok() { return this.order_enable_p && this.order_unit }, // 順番設定ONかつ、順番情報が入っている状態か？

    self_vs_self_p() { return this.order_enable_p && this.order_unit.self_vs_self_p }, // 自分vs自分で対戦している？
    one_vs_one_p()   { return this.order_enable_p && this.order_unit.one_vs_one_p   }, // 1vs1で対戦している？
    many_vs_many_p() { return this.order_enable_p && this.order_unit.many_vs_many_p }, // 3人以上で対戦している？

    watching_member_count() { return this.uniq_member_infos.filter(e => this.member_is_watching(e)).length }, // 観戦者数

    //////////////////////////////////////////////////////////////////////////////// 手番関連

    // -1
    previous_turn_user_name()   { return this.turn_to_user_name(this.current_turn - 1)   }, // 前の局面のメンバーの名前
    previous_turn_self_p()      { return this.previous_turn_user_name === this.user_name }, // 前は自分の手番か？
    // 0
    current_turn_user_name()    { return this.turn_to_user_name(this.current_turn)       }, // 今の局面のメンバーの名前
    current_turn_self_p()       { return this.current_turn_user_name === this.user_name  }, // 今は自分の手番か？
    // +1
    next_turn_user_name()       { return this.turn_to_user_name(this.current_turn + 1)   }, // 次の局面のメンバーの名前
    next_turn_self_p()          { return this.next_turn_user_name === this.user_name     }, // 次は自分の手番か？

    ////////////////////////////////////////////////////////////////////////////////

    i_am_member_p()          { return this.order_enable_p && !!this.order_lookup_from_name(this.user_name) }, // 自分はメンバーに含まれているか？
    i_am_watcher_p()         { return this.order_enable_p && !this.order_lookup_from_name(this.user_name)  }, // 自分は観戦者か？
    my_location()               { return this.user_name_to_initial_location(this.user_name) }, // 自分の色

    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////

    ordered_member_names_oneline() { return this.order_unit.real_order_users(this.change_per, this.start_color).map(e => e ? e.user_name : "?").join("→") }, // 順序(デバッグ用)

    ////////////////////////////////////////////////////////////////////////////////

    // 変更したけど保存せずにモーダルを閉じようとしている？
    os_modal_close_if_not_save_p() { return this.order_enable_p && this.new_v.os_change.has_changes_to_save_p },

    // 最終的に左側に表示する並びになっているメンバーリスト
    // 順番設定されているときは対局者を優先的に上に表示する
    visible_member_infos() {
      if (this.order_enable_p) {
        return _.sortBy(this.member_infos, e => {
          return this.user_name_to_initial_turn(e.from_user_name) ?? this.member_infos.length
        })
      } else {
        return this.member_infos
      }
    },

    // 対局に参加しているメンバー一覧(順不同)
    versus_member_infos() {
      if (this.order_enable_p) {
        return this.member_infos.filter(e => this.user_name_to_initial_turn(e.from_user_name))
      }
    },

    // 黒・白・観戦のグループでユーザー配列を返す
    // 順番設定 ON のときのみ有効
    // { black: [...], white: [...], other: [...] }
    visible_member_groups() {
      Gs.assert(this.order_enable_p, "チーム別のメンバー情報を取得するときは順番設定が有効になっていること")
      return _.groupBy(this.visible_member_infos, e => {
        const location = this.user_name_to_initial_location(e.from_user_name)
        if (location) {
          return location.key
        }
        return "watcher"
      })
    },

    // 自分の色のチームのメンバー数を返す
    my_team_member_count() {
      const location = this.my_location
      if (location) {
        return this.order_unit.team_member_count(location)
      }
    },

    // 自分のチームは二人以上いるか？
    my_team_member_is_many_p() {
      return (this.my_team_member_count ?? 0) >= 2
    },

    // 自分のチームは自分だけか？
    my_team_member_is_one_p() {
      return (this.my_team_member_count ?? 0) === 1
    },
  },
}
