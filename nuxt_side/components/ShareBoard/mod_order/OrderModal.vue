<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 順番設定

      template(v-if="SB.order_enable_p && false")
        span.ml-1.has-text-grey.has-text-weight-normal
          | 参加者{{SB.order_draft.order_flow.main_user_count}}人

    b-button.os_submit_button_for_capybara(@click="apply_handle" size="is-small" v-if="development_p") 確定

    // footer の close_handle は位置がずれて Capybara (spec/system/share_board_spec.rb) で押せないため上にもう1つ設置
    a.mx-2.close_handle_for_capybara.delete(@click="close_handle" v-if="development_p")
    //- template(v-if="!instance")
    b-switch.main_switch(size="is-small" type="is-primary" v-model="SB.order_enable_p" @input="main_switch_handle") 有効

  .modal-card-body(@click="!SB.order_enable_p && main_switch_handle(true)")
    .start_message.has-text-centered.has-text-grey.my-6(v-if="!SB.order_enable_p")
      | 右上のスイッチで有効にしよう

    template(v-if="SB.order_enable_p || development_p")
      //- pre {{JSON.stringify(SB.order_draft.os_change.to_h)}}

      //- https://buefy.org/documentation/tabs
      b-tabs(type="is-boxed" size="is-small" v-model="tab_index" @input="tab_change_handle" expanded)
        template(v-for="e in SB.OrderTabInfo.values")
          b-tab-item(:label="e.name" :header-class="e.key")

      .tab_content.order_tab_main(v-if="SB.order_tab_info.key === 'order_tab_main'")
        .TeamsContainer.is-unselectable
          OrderTeamOne.is_team_black(:items.sync="SB.order_draft.order_flow.order_operation.teams[0]" label="☗" @label_click="swap_handle")
          OrderTeamOne.is_team_white(:items.sync="SB.order_draft.order_flow.order_operation.teams[1]" label="☖" @label_click="swap_handle")
          OrderTeamOne.is_team_watcher(:items.sync="SB.order_draft.order_flow.watch_users" label="観戦" @label_click="all_move_to_watcher_handle")

        .realtime_notice_container.my-4.mx-1.is-unselectable.is_line_break_on(v-if="realtime_notice")
          b-icon.mx-1(:icon="realtime_notice.icon_code" :type="realtime_notice.icon_type")
          .realtime_notice.is-size-7(v-html="realtime_notice.message")

        .support_buttons.mt-4(v-if="support_buttons_show_p")
          b-button.shuffle_all_handle(size="is-small" @click="shuffle_all_handle" v-if="shuffule_all_button_show_p") 全体ｼｬｯﾌﾙ
          b-button.teams_each_shuffle_handle(size="is-small" @click="teams_each_shuffle_handle" v-if="team_each_shuffle_button_show_p") ﾁｰﾑ内ｼｬｯﾌﾙ
          b-button.furigoma_handle(size="is-small" @click="furigoma_handle" v-if="furigoma_button_show_p") 振り駒
          b-button.swap_handle(size="is-small" @click="swap_handle" v-if="swap_handle_button_show_p") 先後入替
          //- b-button.board_preset_modal_open_handle(v-if="SB.debug_mode_p" size="is-small" @click="SB.board_preset_modal_open_handle") 手合割

      .tab_content.order_tab_fes(v-if="SB.order_tab_info.key === 'order_tab_fes'")
        .has-text-centered.is-size-7.is-unselectable
          | 投票でﾁｰﾑ分けするなら
        .buttons.is-centered.mb-0.mt-2
          b-button.mb-0(size="is-small" @click="quiz_maker_handle")
            | お題ﾒｰｶｰ
          b-button.mb-0(size="is-small" type="is-primary" @click="voted_result_to_order_apply_handle" v-if="SB.quiz_received_p")
            | 結果を反映する({{SB.quiz_voted_result.count}}/{{SB.room_user_names.length}})
          b-button.mb-0(size="is-small" type="is-danger" @click="quiz_delete_handle" v-if="SB.quiz_received_p && SB.debug_mode_p")
            | 削除

        .has-text-centered.mb-0.mt-2.is-size-7.is_word_break_on(v-if="SB.quiz_received_p && $GX.present_p(SB.vote_yet_user_names)")
          | まだ投票してない人({{SB.vote_yet_user_names.length}}): {{SB.vote_yet_user_names.join(", ")}}

      .tab_content.order_tab_rule(v-if="SB.order_tab_info.key === 'order_tab_rule'")
        template(v-if="SB.debug_mode_p || SB.AppConfig.foul_mode_ui_show")
          SimpleRadioButton.foul_mode(:base="SB" custom-class="is-small" element_size="is-small" model_name="FoulModeInfo" :sync_value.sync="SB.order_draft.foul_mode_key" @user_input="foul_mode_key_updated")

        SimpleRadioButton.change_per(
          :base="SB"
          custom-class="is-small"
          element_size="is-small"
          model_name="ChangePerInfo"
          :sync_value="SB.order_draft.change_per"
          @update:sync_value="v => SB.order_draft.change_per = _.max([1, $GX.to_i(v)])"
          )
        //- | {{SB.order_draft.change_per}}

        SimpleRadioButton.think_mark_receive_scope(:base="SB" custom-class="is-small" element_size="is-small" model_name="ThinkMarkReceiveScopeInfo" :sync_value.sync="SB.order_draft.think_mark_receive_scope_key")

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    template(v-if="SB.order_enable_p")
      b-button.apply_button(@click="apply_handle" :type="apply_button_type") 確定
      template(v-if="SB.debug_mode_p")
        b-button.order_modal_force_submit_button(@click="order_modal_force_submit_handle") 確定(force)
</template>

<script>
const SHUFFLE_MAX = 8
import { GX } from "@/components/models/gx.js"
import { FurigomaPack  } from "@/components/models/furigoma/furigoma_pack.js"
import _ from "lodash"
import { support_child } from "../support_child.js"
import ReformConductModal from "./ReformConductModal.vue"

export default {
  name: "OrderModal",
  mixins: [support_child],
  provide() {
    return {
      TheOSM: this,
    }
  },
  data() {
    return {
      reform_conduct_modal_instance: null,
      tab_index: this.SB.order_tab_info.code,
    }
  },
  beforeDestroy() {
    this.reform_conduct_modal_close()
  },

  watch: {
    tab_index(v) { this.SB.order_tab_key = this.SB.OrderTabInfo.fetch(v).key },
  },

  methods: {
    tab_change_handle(index) {
      this.sfx_click()
      this.SB.sb_talk(this.SB.OrderTabInfo.fetch(index).name)
    },

    //////////////////////////////////////////////////////////////////////////////// イベント

    main_switch_handle(v) {
      this.sfx_play_toggle(v)
      this.SB.order_switch_share({order_enable_p: v, message: v ? "有効" : "無効"})

      // 対局者が0人であれば反映する(のはおかしいのでなにもしない)
      // if (v) {
      //   if (this.SB.order_flow.main_user_count === 0) {
      //     this.SB.order_draft_publish("")
      //   }
      // }
    },

    close_handle() {
      if (this.SB.order_modal_close_if_not_save_p) {
        this.SB.order_modal_close_confirm({
          onConfirm: () => {
            this.sfx_click()
            this.SB.order_modal_close()
          },
        })
        return
      }
      this.sfx_click()
      this.SB.order_modal_close()
    },

    // 全体ｼｬｯﾌﾙ
    shuffle_all_handle() {
      this.sfx_click()
      this.SB.order_draft.order_flow.shuffle_all()
      this.SB.al_share({label: "全体ｼｬｯﾌﾙ", message: "全体ｼｬｯﾌﾙしました"})
    },

    // チーム内シャッフル
    teams_each_shuffle_handle() {
      this.sfx_click()
      this.SB.order_draft.order_flow.teams_each_shuffle()
      this.SB.al_share({label: "ﾁｰﾑ内ｼｬｯﾌﾙ", message: "ﾁｰﾑ内ｼｬｯﾌﾙしました"})
    },

    // 振り駒
    furigoma_handle() {
      if (this.invalid_member_empty()) { return }
      if (this.invalid_team_empty()) { return }
      if (this.swap_invalid("振り駒")) { return }
      const furigoma_pack = FurigomaPack.call({
        furigoma_random_key: this.$route.query.furigoma_random_key,
        toss_count: this.$route.query.toss_count,
      })
      this.sfx_click()
      this.SB.order_draft.order_flow.furigoma_core(furigoma_pack.swap_p)
      const item = this.SB.order_draft.order_flow.first_user(this.SB.start_color)
      let who = "誰かさん"
      if (item) {
        who = this.user_call_name(item.user_name)
      }
      const message = `振り駒をした結果、${furigoma_pack.message}で${who}の先手になりました`
      this.SB.al_share({label: furigoma_pack.piece_names, message: message})
    },

    // 先後入替
    swap_handle() {
      if (this.swap_invalid("先後入替")) { return }
      this.sfx_click()
      this.SB.order_draft.order_flow.swap_run()
      this.SB.al_share({label: "先後入替", message: "チームを入れ替えました"})
    },

    // すべてのメンバーを観戦に移動する
    all_move_to_watcher_handle(e) {
      this.sfx_click()
      this.SB.order_draft.order_flow.all_move_to_watcher()
      this.toast_primary("いったん全員を観戦者にしました")
    },

    // 偶数人数であること
    swap_invalid(name) {
      if (!this.SB.order_draft.order_flow.swap_enable_p) {
        return this.error_message_show(`参加人数が奇数のときはチーム編成が変わるので${name}できません`)
      }
    },

    os_before_apply() {
      // let v = this.SB.order_draft.change_per
      // v = GX.to_i(v)
      // if (v <= 0) {
      //   v = 1
      // }
      // this.SB.order_draft.change_per = v
    },

    invalid_member_empty() {
      return this.error_message_show(this.SB.order_draft.order_flow.member_empty_message)
    },
    invalid_team_empty() {
      if (this.self_vs_self_mode_p) {
      } else {
        return this.error_message_show(this.SB.order_draft.order_flow.team_empty_message)
      }
    },
    error_message_show(message) {
      if (GX.present_p(message)) {
        this.sfx_play("x")
        this.toast_warn(message)
        return true
      }
    },

    invalid_options() {
      if (GX.blank_p(this.SB.order_draft.change_per)) {
        return this.error_message_show("「X手指したら交代する」の項目を正しく入力しよう")
      }
    },

    // 確定
    apply_handle() {
      this.os_before_apply()
      if (this.invalid_member_empty()) { return }
      if (this.invalid_team_empty()) { return }
      if (this.invalid_options()) { return }
      this.sfx_click()
      if (!this.SB.order_draft.os_change.has_changes_to_save_p) {
        this.toast_primary(`変更はありません`)
        this.SB.order_modal_close()
        return
      }
      this.SB.order_draft_publish("順番設定を反映しました")
      GX.delay_block(this.__SYSTEM_TEST_RUNNING__ ? 0 : 3.0, () => this.SB.cc_next_message())
    },

    // バリデーションなしで確定する
    order_modal_force_submit_handle() {
      this.os_before_apply()
      if (this.invalid_options()) { return }
      this.SB.order_draft_publish("バリデーションなしで順番設定を確定しました")
    },

    hint_handle(model) {
      this.sfx_stop_all()
      this.sfx_click()
      this.toast_primary(model.hint_messages.join(""), {duration_sec: 7})
    },

    ////////////////////////////////////////////////////////////////////////////////

    quiz_maker_handle() {
      this.sfx_click()
      this.SB.order_modal_close()
      this.SB.quiz_maker_handle()
      this.SB.al_share({label: "お題作成", message: "お題を作成しています"})
    },

    voted_result_to_order_apply_handle() {
      this.sfx_click()
      this.SB.voted_result_to_order_apply()
      this.SB.al_share({label: "結果反映", message: "投票の結果でチーム分けしました"})
      this.tab_index = this.SB.OrderTabInfo.fetch("order_tab_main").code
    },

    quiz_delete_handle() {
      this.sfx_click()
      this.SB.quiz_delete()
      this.SB.al_share({label: "お題削除", message: "お題を削除しました"})
    },

    ////////////////////////////////////////////////////////////////////////////////

    foul_mode_key_updated(foul_mode_key) {
      if (foul_mode_key === this.SB.FoulModeInfo.fetch("takeback").key) {
        this.reform_conduct_modal_open()
      }
    },
    reform_conduct_modal_open() {
      if (this.reform_conduct_modal_instance == null) {
        this.reform_conduct_modal_instance = this.modal_card_open({
          component: ReformConductModal,
        })
      }
    },
    reform_conduct_modal_close() {
      if (this.reform_conduct_modal_instance) {
        this.reform_conduct_modal_instance.close()
        this.reform_conduct_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    ////////////////////////////////////////////////////////////////////////////////

    furigoma_button_show_p()          { return this.SB.order_draft.order_flow.team_member_counts.every(e => (e >= 1))                        }, // 振り駒ボタンを表示する？
    shuffule_all_button_show_p()      { return this.SB.order_draft.order_flow.main_user_count >= 3                                           }, // 全体シャッフルボタン表示する？
    swap_handle_button_show_p()       { return this.SB.order_draft.order_flow.team_member_counts.some(e => (e >= 1)) && this.SB.debug_mode_p }, // どちらかのチームに1人以上いる？
    team_each_shuffle_button_show_p() { return this.SB.order_draft.order_flow.team_member_counts.some(e => (e >= 2))                         }, // どちらかのチームに2人以上いる？

    support_buttons_show_p() {
      return [
        this.furigoma_button_show_p,
        this.shuffule_all_button_show_p,
        this.swap_handle_button_show_p,
        this.team_each_shuffle_button_show_p,
      ].some(e => e)
    },

    ////////////////////////////////////////////////////////////////////////////////

    self_vs_self_mode_p() { return this.SB.self_vs_self_enable_p && this.SB.order_draft.order_flow.main_user_count === 1 }, // 面子が1人で自分vs自分が可能な状態か？

    apply_button_type() {
      if (this.SB.order_draft.os_change.has_changes_to_save_p) {
        return "is-primary"
      }
    },

    realtime_notice() {
      let hv = null
      if (hv == null) {
        if (this.SB.order_draft.order_flow.empty_p) {
          hv = {
            icon_code: "alert-circle-outline",
            icon_type: "is-danger",
            message: "対局する人を☗と☖に放り込もう",
          }
        }
      }
      if (hv == null) {
        const location = this.SB.order_draft.order_flow.team_empty_location
        if (location) {
          let aside_note = ""
          if (this.self_vs_self_mode_p) {
            const elem = this.SB.order_draft.order_flow.flat_uniq_users_sole
            aside_note = `(この状態でも${this.SB.user_call_name(elem.user_name)}同士で対局可)`
          }
          hv = {
            icon_code: "alert-circle-outline",
            icon_type: "is-danger",
            message: GX.str_strip(`次は${location.human_color_name}チームを決めよう ${aside_note}`),
          }
        }
      }
      if (hv == null) {
        const b_vs_w = this.SB.order_draft.order_flow.team_member_counts.join(" vs ")
        hv = {
          icon_code: "check-bold",
          icon_type: "is-success",
          message: `${b_vs_w} で対局できます`,
        }
      }
      return hv
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.OrderModal
  +modal_width(480px)
  // +modal_width_auto

  .TeamsContainer
    // width: 12rem
    // width: 100%
    display: flex // OrderTeamOne を横並び化
    justify-content: center
    gap: 6px

  .realtime_notice_container
    display: flex
    align-items: center
    justify-content: center

  .support_buttons
    display: flex
    align-items: center
    justify-content: center
    gap: 0.5rem

  .furigoma_handle
    .icon
      scale: 1.5
      color: $grey

  .swap_handle
    .icon
      margin: 0 0.1rem ! important
      scale: 0.75
      color: $grey

  .modal-card-body
    padding: 1rem
    .b-tabs, .tab-content
      padding: 0
    .b-tabs
      margin-top: 0
      margin-bottom: 0
    .tab_content
      margin-top: 1rem
      &.order_tab_rule
        padding: 0 0.75rem

        .field
          margin: 0

        display: flex
        flex-direction: column
        gap: 1rem

.STAGE-development
  .OrderModal
    .modal-card-body
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .start_message
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .TeamsContainer
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .support_buttons
      border: 1px dashed change_color($primary, $alpha: 0.5)
    // .tab_content
    //   border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
