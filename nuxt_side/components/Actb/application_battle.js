import { Question } from "./models/question.js"
import { Battle } from "./models/battle.js"
import { MemberInfo } from "./models/member_info.js"

import { application_battle_timer } from "./application_battle_timer.js"

import { application_battle_sy_marathon  } from "./application_battle_sy_marathon.js"
import { application_battle_sy_singleton } from "./application_battle_sy_singleton.js"
import { application_battle_sy_hybrid    } from "./application_battle_sy_hybrid.js"
import { application_battle_sy_versus    } from "./application_battle_sy_versus.js"

export const application_battle = {
  mixins: [
    application_battle_timer,

    application_battle_sy_marathon,
    application_battle_sy_singleton,
    application_battle_sy_hybrid,
    application_battle_sy_versus,
  ],
  data() {
    return {
      // 共通
      battle:            null,  // 問題と memberships が入っている
      member_infos_hash: null,  // 各 membership_id はどこまで進んでいるかわかる
      x_mode:            null,  // バトル中の状態遷移
      practice_p:        null,  // 練習モードを選択中 (用途は matching_search に渡すためだけにすること)

      // シングルトン専用
      share_sfen:        null, // 自分の操作を相手に伝える棋譜
      share_turn_offset: null, // 自分の操作を相手に伝えたときの手数

      // 共通(別になくてもよいもの)
      battle_count:        null, // 同じ相手との対戦回数
      question_index:      null, // 現在の問題インデックス
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

      // this.debug_say(`**→ [${membership.user.name}][${action}] ` + JSON.stringify(params))
      this.$ac_battle.perform(action, params) // --> base/channels/actb/battle_channel.rb
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

      this.question_index = 0

      // if (
      //   this.info.warp_to === "battle_sy_versus" ||
      //   this.info.warp_to === "battle_sy_marathon" ||
      //     this.info.warp_to === "battle_sy_singleton" ||
      //     this.info.warp_to === "battle_sy_hybrid") {
      //   this.start_hook()
      //   return
      // }

      this.__assert__(this.$ac_battle == null, "this.$ac_battle == null")
      this.$ac_battle = this.ac_subscription_create({channel: "Actb::BattleChannel", battle_id: this.battle.id}, {
        connected: () => {
          // 結果画面でスマホを閉じる→スマホ開くで再びconnectedが呼ばれるので注意
          if (this.sub_mode === "sm1_standby") {
            this.start_hook()
          }
        },
        received: (data) => {
          this.debug_say(`**← [${data.bc_action}] ` + JSON.stringify(data.bc_params))
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

      if (this.versus_mode_p) {
        this.vs_func_init()
      }

      if (this.question_mode_p) {
        this.__assert__(this.battle.best_questions.length >= 1, "対戦開始しようとしたが問題集が空")
      }

      this.debug_alert("battle 接続")

      this.ok_notice("対戦開始")

      if (this.question_mode_p) {
        this.sub_mode = "sm2_readygo"
        this.delay_block(this.config.readygo_delay, () => this.sm3_deden_trigger())
      }
    },

    sm3_deden_trigger() {
      this.sound_play("deden")
      this.sub_mode = "sm3_deden"
      this.delay_block(this.config.deden_delay, () => this.sm4_tactic_trigger())
    },

    sm4_tactic_trigger() {
      this.sub_mode = "sm4_tactic"

      this.x_mode = "x1_think"

      this.share_sfen = null

      if (this.current_question.direction_message) {
        this.say(this.current_question.direction_message)
      }
    },

    q_turn_offset_set(turn) {
      this.share_turn_offset = turn

      // 3手詰を7手ほど進めたたときもタイムアウト相当の処理へ進む
      const max = this.current_question.moves_count_max + this.config.turn_limit_lazy_count
      if (turn >= max) {
        this.x2_play_timeout_handle()
      }
    },

    play_mode_advanced_full_moves_sfen_set(e) {
      if (this.sub_mode === "sm4_tactic") {

        if (this.current_strategy_key === "sy_singleton") {
          // 安全のため残り0秒になってから操作しても無効とする
          if (this.ops_rest_seconds === 0) {
            return
          }

          // 駒を1つでも動かしたら3秒に復帰する
          if (this.x_mode === "x2_play") {
            this.ops_interval_restart()
          }

          this.play_board_share(e.sfen)
        }

        if (this.current_question.sfen_valid_p(e.sfen)) {
          this.kotae_sentaku("correct")
        }
      }
    },

    play_board_share(share_sfen) {
      this.ac_battle_perform("play_board_share", { // 戻値なし
        share_sfen: share_sfen,
      }) // --> base/channels/actb/battle_channel.rb
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
      // this.ac_battle_perform("kotae_sentaku", {
      //   ms_flip: ms_flip,
      //   question_id: this.current_question.id,
      //   question_index: this.question_index,
      //   ox_mark_key: ox_mark_key,
      // }) // --> base/channels/actb/battle_channel.rb

    },

    ////////////////////////////////////////////////////////////////////////////////

    // 正解または不正解
    // ここにくるのは correct と timeout しかない
    kotae_sentaku(ox_mark_key, ms_flip = false) {
      this.__assert__(ox_mark_key === "correct" || ox_mark_key === "timeout", "ox_mark_keyがおかしい")
      this.ac_battle_perform("kotae_sentaku", {
        ms_flip: ms_flip,
        question_id: this.current_question.id,
        question_index: this.question_index,
        ox_mark_key: ox_mark_key,
      }) // --> base/channels/actb/battle_channel.rb
    },
    // 状況を反映する
    kotae_sentaku_broadcasted(params) {
      const ox_mark_info = this.OxMarkInfo.fetch(params.ox_mark_key) // 正解・不正解
      const mi = this.member_infos_hash[params.membership_id]          // 対応する membership の情報

      // 効果音
      this.sound_play(ox_mark_info.sound_key)

      if (this.current_strategy_key === "sy_marathon") {
        this.seikai_user_niha_maru(mi, ox_mark_info) // 正解時は正解したユーザーが送信者なので正解者には○

        if (ox_mark_info.key === "timeout") {
          mi.score_add(-1)
          mi.ox_list.push("timeout")
        }

        this.itteijikan_maru_hyouji(mi, ox_mark_info) // なくてもいいけど○を一定時間表示

        if (params.membership_id === this.current_membership.id) {
          this.sub_mode_set_by_ox_mark_info(ox_mark_info)
          this.delay_and_judgement_run_or_next_trigger(ox_mark_info)
        }
      }

      // 正解時         → 正解したユーザーが送信者
      // タイムアウト時 → プレイマリーユーザーが送信者
      if (this.current_strategy_key === "sy_singleton" || this.current_strategy_key === "sy_hybrid") {
        this.sub_mode_set_by_ox_mark_info(ox_mark_info)
        this.seikai_user_niha_maru(mi, ox_mark_info)  // 正解時は正解したユーザーが送信者なので正解者には○
        this.ryousya_jikangire(ox_mark_info)          // タイムアウトのときは両者に時間切れ
        if (ox_mark_info.key === "correct") {        // 正解のときだけでよい。タイムアウトは両者なので通知した片方に×がでるのは変
          this.itteijikan_maru_hyouji(mi, ox_mark_info) // なくてもいいけど○を一定時間表示
        }
        if (this.leader_p) {
          this.delay_and_judgement_run_or_next_trigger(ox_mark_info) // [ONCE]
        }
      }
    },

    ////
    sub_mode_set_by_ox_mark_info(ox_mark_info) {
      if (ox_mark_info.key === "correct") {
        this.sub_mode = "sm5_correct"
      }
      if (ox_mark_info.key === "timeout") {
        this.sub_mode = "sm6_timeout"
      }
    },

    // タイムアウトのときは両者に時間切れ
    ryousya_jikangire(ox_mark_info) {
      if (ox_mark_info.key === "timeout") {
        _.each(this.member_infos_hash, (v, k) => v.ox_list.push("timeout"))
      }
    },

    // 正解時は正解したユーザーが送信者なので正解者には○
    seikai_user_niha_maru(mi, ox_mark_info) {
      if (ox_mark_info.key === "correct") {
        mi.score_add(ox_mark_info.score)
        mi.ox_list.push("correct")
      }
    },

    itteijikan_maru_hyouji(mi, ox_mark_info) {
      this.delay_stop(mi.delay_id) // 前のが動いている場合があるので止める
      mi.latest_ox = ox_mark_info.key
      mi.delay_id = this.delay_block(ox_mark_info.delay_second, () => {
        mi.delay_id = null
        mi.latest_ox = null
      })
    },

    delay_and_judgement_run_or_next_trigger(ox_mark_info) {
      this.delay_block(ox_mark_info.delay_second, () => {
        if (this.battle_end_p || this.next_question_empty_p) {
          this.ac_battle_perform("judgement_run", {member_infos_hash: this.member_infos_hash}) // --> base/channels/actb/battle_channel.rb
        } else {
          this.next_trigger()
        }
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    // sy_singleton ではリーダーだけが呼ぶ
    // 両者が呼ぶようにするとまずい。わずかな時間差で呼ばれたとき問題が2度インクリメントされてしまう
    next_trigger() {
      this.ac_battle_perform("next_trigger", {
        question_index: this.question_index + 1, // 次に進めたい(希望)
        question_id: this.next_question.id,
      }) // --> base/channels/actb/battle_channel.rb
    },
    next_trigger_broadcasted(params) {
      if (this.current_strategy_key === "sy_marathon") {
        if (params.membership_id === this.current_membership.id) {
          this.question_index = params.question_index // 自分だったら次に進める
          this.sm3_deden_trigger()
        }
      }
      if (this.current_strategy_key === "sy_singleton" || this.current_strategy_key === "sy_hybrid") {
        this.question_index = params.question_index // 相手もそろって次に進める
        this.sm3_deden_trigger()
      }
    },

    // 早押しボタンを押した(解答権はまだない)
    answer_button_push_handle(ms_flip = false) {
      this.ac_battle_perform("answer_button_push_handle", {
        ms_flip: ms_flip,
        question_id: this.current_question.id,
      }) // --> base/channels/actb/battle_channel.rb
    },
    answer_button_push_handle_broadcasted(params) {
      // 「わかった」を押した直後に時間切れとなった場合、時間切れ表示中に answer_button_push_handle_broadcasted が発生し、
      // 解答権を取得してしまう。そして数秒後、次の問題に切り替わったあたりで解答権を失う
      // つまり、残り0.1秒で「わかった」すると次の問題を答える権利がなくなる
      // これを防ぐために、時間切れになった瞬間、answer_button_push_handle_broadcasted を処理しないようにする
      if (this.sub_mode !== "sm4_tactic") {
        this.clog("わかったを押した直後に時間切れになったためわかったを無効とする")
        return
      }

      this.sound_stop_all()          // クエストを読み上げている場合は停止する
      this.sound_play("poon")
      const mi = this.member_infos_hash[params.membership_id]
      if (params.membership_id === this.current_membership.id) {
        // 先に解答ボタンを押した側
        this.x_mode = "x2_play"
        this.ops_interval_start_onece()
      } else {
        // 解答ボタンを押さなかった側
        // 元々誤答していたら解答権利復活させる
        if (this.base.config.otetuki_release_p) {
          if (this.current_mi.otetuki_p(params.question_id)) {
            this.current_mi.otetuki_off(params.question_id)
          }
        }
        this.x_mode = "x3_see"
        this.share_sfen = this.current_question.init_sfen // 初期状態にしておく
        this.share_turn_offset = 0             // 相手が操作中(○手目)の部分を0に戻す
      }
    },

    // 早押しボタンを押して解答中に時間切れ
    x2_play_timeout_handle(ms_flip = false) {
      this.ac_battle_perform("x2_play_timeout_handle", {
        ms_flip: ms_flip,
        question_id: this.current_question.id,
      }) // --> base/channels/actb/battle_channel.rb
    },
    // sy_singleton での操作中の時間切れは不正解相当
    x2_play_timeout_handle_broadcasted(params) {
      const mi = this.member_infos_hash[params.membership_id]
      mi.ox_list.push("mistake")
      mi.score_add(-1)
      mi.otetuki_on(params.question_id)

      if (params.membership_id === this.current_membership.id) {
      } else {
      }

      if (this.base.config.otetuki_release_p) {
        // 解答権が相手にうつる場合
      } else {
        // 両者がおてつきしたらリーダーがタイムアウトとみなして次の問題に移行させる
        if (this.otetuki_all_p || this.room.bot_user_id) {
          if (this.leader_p) {
            this.kotae_sentaku('timeout') // [ONCE]
          }
          return
        }
      }

      this.sound_play("mistake")
      this.x_mode = "x1_think"
      this.ops_interval_stop()
    },

    // private

    // 結果画面へ
    judge_final_set_broadcasted(params) {
      this.debug_alert("結果画面へ")
      this.result_setup(params.battle)
    },

    battle_continue_handle(ms_flip = false) {
      if (ms_flip) {
      } else {
        // 自分のときだけ成らす
        this.sound_play("click")
      }
      this.ac_battle_perform("battle_continue_handle", {ms_flip: ms_flip})
    },
    battle_continue_handle_broadcasted(params) {
      this.continue_tap_counts = params.continue_tap_counts

      if (params.membership_id === this.current_membership.id) {
        // 自分が先に再戦希望して、それが練習モードであれば、相手の再戦希望を押してあげる
        if (this.room.bot_user_id) {
          this.delay_block(3, () => this.battle_continue_handle(true))
        }
      } else {
        // 相手から通知が来た
      }

      this.$buefy.toast.open({message: "再戦希望", position: "is-top", queue: false})
      this.say("再戦希望")
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
      if (this.room.bot_user_id) {
        this.sound_play("pon")
        this.say("おしまい")
      } else {
        this.sound_play(this.base.current_membership.judge.key)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 部屋から退出する
    room_leave_handle() {
      this.sound_play("click")
      this.battle_leave_handle()
      if (this.room.bot_user_id) {
        this.lobby_setup_without_cable()
      } else {
        this.lobby_setup()
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 退出通知
    battle_leave_handle(ms_flip = false) {
      this.ac_battle_perform("battle_leave_handle", {ms_flip: ms_flip})
    },
    battle_leave_handle_broadcasted(params) {
      const membership = this.battle.memberships.find(e => e.id === params.membership_id)
      this.debug_say(`**${membership.user.name}さんが退出したことを知った`)
      this.member_infos_hash[membership.id].member_active_p = false // 退出記録
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
    current_question() {
      const v = this.battle.best_questions[this.question_index]
      // this.__assert__(v, `[${this.question_index}]の問題が空`)
      return v
    },
    next_question() {
      const v = this.battle.best_questions[this.question_index + 1]
      this.__assert__(v, "next_question is blank")
      return v
    },

    ////////////////////////////////////////////////////////////////////////////////

    next_question_exist_p() {
      return !this.next_question_empty_p
    },
    next_question_empty_p() {
      return (this.question_index + 1) >= this.battle.questions_count
    },
    score_orderd_memberships() {
      return _.sortBy(this.battle.memberships, e => -this.member_infos_hash[e.id].b_score)
    },
    score_debug_info() {
      return this.score_orderd_memberships.map(e => `${e.user.name}(${this.member_infos_hash[e.id].b_score})`).join(", ")
    },
    b_score_max() {
      return _.max(_.map(this.member_infos_hash, (e, membership_id) => e.b_score))
    },
    b_score_max_for_win() {
      return this.current_rule_info.b_score_max_for_win
    },
    // バトル終了条件
    battle_end_p() {
      return this.b_score_max >= this.b_score_max_for_win
    },

    //////////////////////////////////////////////////////////////////////////////// 両方誤答した？

    otetuki_all_p() {
      return _.every(this.member_infos_hash, (v, k) => v.otetuki_p(this.current_question.id))
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
