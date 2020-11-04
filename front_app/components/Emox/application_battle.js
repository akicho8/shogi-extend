import { Battle } from "./models/battle.js"
import { MemberInfo } from "./models/member_info.js"

import { application_battle_timer } from "./application_battle_timer.js"

import { application_battle_versus    } from "./application_battle_versus.js"

export const application_battle = {
  mixins: [
    application_battle_timer,
    application_battle_versus,
  ],
  data() {
    return {
      // 共通
      battle:            null,  // 問題と memberships が入っている
      member_infos_hash: null,  // 各 membership_id はどこまで進んでいるかわかる
      x_mode:            null,  // バトル中の状態遷移

      // シングルトン専用
      share_sfen:        null, // 自分の操作を相手に伝える棋譜
      share_turn_offset: null, // 自分の操作を相手に伝えたときの手数

      // 共通(別になくてもよいもの)
      battle_count:        null, // 同じ相手との対戦回数
      continue_tap_counts: null, // それぞれの再戦希望数
    }
  },

  methods: {
    ac_battle_perform(action, params = {}) {
      params = {...params}

      // membership_id が空であれば自分を埋める
      if (!params.membership_id) {
        params.membership_id = this.current_membership.id
      }

      // ms_flip があれば逆にする
      if (true) {
        if (params.ms_flip) {
          if (params.membership_id === this.current_membership.id) {
            params.membership_id = this.opponent_membership.id
          } else {
            params.membership_id = this.current_membership.id
          }
        }
        delete params.ms_flip
      }

      this.$ac_battle.perform(action, params) // --> app/channels/emox/battle_channel.rb
    },

    battle_unsubscribe() {
      this.ac_unsubscribe("$ac_battle")
    },

    battle_setup(battle) {
      // this.$ga.event("open", {event_category: "対戦中"})

      this.battle_unsubscribe()

      this.battle = new Battle(battle)

      this.mode = "battle"
      this.sub_mode = "sm1_standby"

      this.continue_tap_counts = {}

      this.member_infos_hash = this.battle.memberships.reduce((a, e) => ({...a, [e.id]: new MemberInfo(e.id)}), {})

      this.__assert__(this.$ac_battle == null, "this.$ac_battle == null")
      this.$ac_battle = this.ac_subscription_create({channel: "Emox::BattleChannel", battle_id: this.battle.id}, {
        connected: () => {
          // 結果画面でスマホを閉じる→スマホ開くで再びconnectedが呼ばれるので注意
          if (this.sub_mode === "sm1_standby") {
            this.start_hook()
          }
        },
        received: (data) => {
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    start_hook() {
      this.battle_count += 1

      if (this.info.warp_to === "result") {
        this.result_setup(this.info.battle)
        return
      }

      this.vs_func_init()

      this.debug_alert("battle 接続")

      this.toast_ok("対戦開始")
    },

    play_board_share(share_sfen) {
      this.ac_battle_perform("play_board_share", { // 戻値なし
        share_sfen: share_sfen,
      }) // --> app/channels/emox/battle_channel.rb
    },
    play_board_share_broadcasted(params) {
      if (params.membership_id === this.current_membership.id) {
        // 自分は操作中なので何も変化させない
      } else {
        // 自分の操作を相手の盤面で動かす
        this.share_sfen = params.share_sfen
        this.sound_play("piece_sound") // shogi-player で音が鳴らないのでここで鳴らす
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    skip_handle(ms_flip = false) {
    },

    ////////////////////////////////////////////////////////////////////////////////

    // private

    // 結果画面へ
    judge_final_set_broadcasted(params) {
      debugger
      this.debug_alert("結果画面へ")
      this.result_setup(params.battle)
    },

    battle_continue_force_handle() {
      this.sound_play("click")
      this.ac_battle_perform("battle_continue_force_handle")
    },

    member_disconnect_handle(ms_flip = false) {
      this.ac_battle_perform("member_disconnect_handle", {ms_flip: ms_flip})
    },

    ////////////////////////////////////////////////////////////////////////////////

    result_setup(battle) {
      this.battle = new Battle(battle)
      this.mode = "result"
      this.sound_play(this.base.current_membership.judge.key)
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 部屋から退出する
    room_leave_handle() {
      this.sound_play("click")
      // this.battle_leave_handle()
      // if (this.room.bot_user_id) {
      //   this.lobby_setup_without_cable()
      // } else {
      this.lobby_setup()
    },
  },

  computed: {
    leader_p() {
      return this.battle.memberships[this.base.config.leader_index].id === this.current_membership.id
    },
    current_membership() {
      const v = this.battle.memberships.find(e => e.user.id === this.current_user.id)
      this.__assert__(v, "current_membership is blank")
      return v
    },
    opponent_membership() {
      const v = this.battle.memberships.find(e => e.user.id !== this.current_user.id)
      this.__assert__(v, "opponent_membership is blank")
      return v
    },
    current_mi() {
      return this.member_infos_hash[this.current_membership.id]
    },
    opponent_mi() {
      return this.member_infos_hash[this.opponent_membership.id]
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 自分が必ず左側にいる memberships
    // -1:左 +1:右
    ordered_memberships() {
      if (this.base.config.self_is_left_side_p)  {
        return _.sortBy(this.battle.memberships, e => e.user.id === this.current_user.id ? -1 : 0)
      } else {
        return this.battle.memberships
      }
    },
  },
}
