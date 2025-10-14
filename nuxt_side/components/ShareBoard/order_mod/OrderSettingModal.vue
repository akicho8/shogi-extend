<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 順番設定

      template(v-if="SB.order_enable_p && false")
        span.ml-1.has-text-grey.has-text-weight-normal
          | 参加者{{SB.new_v.order_unit.main_user_count}}人

    b-button.os_submit_button_for_capybara(@click="apply_handle" size="is-small" v-if="development_p") 確定

    // footer の close_handle は位置がずれて Capybara (spec/system/share_board_spec.rb) で押せないため上にもう1つ設置
    a.mx-2.close_handle_for_capybara.delete(@click="close_handle" v-if="development_p")
    //- template(v-if="!instance")
    b-switch.main_switch(size="is-small" type="is-primary" v-model="SB.order_enable_p" @input="main_switch_handle") 有効

  .modal-card-body(@click="!SB.order_enable_p && main_switch_handle(true)")
    .start_message.has-text-centered.has-text-grey.my-6(v-if="!SB.order_enable_p")
      | 右上のスイッチで有効にしよう

    template(v-if="SB.order_enable_p || development_p")
      //- pre {{JSON.stringify(SB.new_v.os_change.to_h)}}
      .TeamsContainer
        template(v-if="SB.new_v.order_unit.order_state.state_name === 'O1State'")
          OrderTeamOne.dnd_both(:items.sync="SB.new_v.order_unit.order_state.users"   label="対局")
        template(v-if="SB.new_v.order_unit.order_state.state_name === 'O2State'")
          OrderTeamOne.dnd_black(:items.sync="SB.new_v.order_unit.order_state.teams[0]" label="☗")
          OrderTeamOne.dnd_white(:items.sync="SB.new_v.order_unit.order_state.teams[1]" label="☖")
        OrderTeamOne.dnd_watch_users(:items.sync="SB.new_v.order_unit.watch_users" label="観戦")

      .shuffle_buttons.mt-4
        b-button.shuffle_all_handle(size="is-small" @click="shuffle_all_handle") 全体ｼｬｯﾌﾙ
        b-button.teams_each_shuffle_handle(size="is-small" @click="teams_each_shuffle_handle") ﾁｰﾑ内ｼｬｯﾌﾙ
        b-button.swap_handle(size="is-small" @click="swap_handle")
          .is-inline-flex.is-align-items-center
            | ☗
            b-icon(icon="swap-horizontal")
            | ☖

      .buttons.is-centered.mb-0.mt-4
        b-button.furigoma_handle.mb-0(@click="furigoma_handle")
          | 🎲
          span.ml-2 振り駒

      hr.my-4

      .has-text-centered.is-size-7
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

      hr.my-4

      .buttons.is-centered.mb-0.mt-2(v-if="!option_block_show_p")
        b-button.mb-0(size="is-small" @click="option_block_show_handle" icon-left="cog") オプション

      .columns.is-multiline.other_setting.is-marginless.is-variable.is-0.has-background-white-ter.box(v-if="option_block_show_p")
        .column.is-12(v-if="SB.debug_mode_p")
          SimpleRadioButton.foul_mode(:base="SB" custom-class="is-small" element_size="is-small" model_name="FoulModeInfo" :sync_value.sync="SB.new_v.foul_mode_key")
        .column.is-12(v-if="SB.debug_mode_p")
          SimpleRadioButton.auto_resign(:base="SB" custom-class="is-small" element_size="is-small" model_name="AutoResignInfo" :sync_value.sync="SB.new_v.auto_resign_key")
        .column.is-12
          SimpleRadioButton.change_per(
            :base="SB"
            custom-class="is-small"
            element_size="is-small"
            model_name="ChangePerInfo"
            :sync_value="SB.new_v.change_per"
            @update:sync_value="v => SB.new_v.change_per = _.max([1, $GX.to_i(v)])"
            )
          //- | {{SB.new_v.change_per}}
        .column.is-12
          SimpleRadioButton.think_mark_receive_scope(:base="SB" custom-class="is-small" element_size="is-small" model_name="ThinkMarkReceiveScopeInfo" :sync_value.sync="SB.new_v.think_mark_receive_scope_key")

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    template(v-if="SB.order_enable_p")
      b-button.apply_button(@click="apply_handle" :type="submit_button_color") 確定
      template(v-if="SB.debug_mode_p")
        b-button.os_modal_force_submit_button(@click="os_modal_force_submit_handle") 確定(force)
</template>

<script>
const SHUFFLE_MAX = 8
import { GX } from "@/components/models/gx.js"
import { FurigomaPack  } from "@/components/models/furigoma/furigoma_pack.js"
import { Location      } from "shogi-player/components/models/location.js"
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "OrderSettingModal",
  mixins: [support_child],
  provide() {
    return {
      TheOSM: this,
    }
  },
  data() {
    return {
      option_block_show_p: this.SB.debug_mode_p,
    }
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// イベント

    main_switch_handle(v) {
      this.sfx_play_toggle(v)
      this.SB.order_switch_share({order_enable_p: v, message: v ? "有効" : "無効"})

      // 対局者が0人であれば反映する(のはおかしいのでなにもしない)
      // if (v) {
      //   if (this.SB.order_unit.main_user_count === 0) {
      //     this.SB.new_order_share("")
      //   }
      // }
    },

    close_handle() {
      if (this.SB.os_modal_close_if_not_save_p) {
        this.SB.os_modal_close_confirm({
          onConfirm: () => {
            this.sfx_click()
            this.SB.os_modal_close()
          },
        })
        return
      }
      this.sfx_click()
      this.SB.os_modal_close()
    },

    // 全体ｼｬｯﾌﾙ
    shuffle_all_handle() {
      this.sfx_click()
      this.SB.new_v.order_unit.shuffle_all()
      this.SB.al_share({label: "全体ｼｬｯﾌﾙ", message: "全体ｼｬｯﾌﾙしました"})
    },

    // チーム内シャッフル
    teams_each_shuffle_handle() {
      this.sfx_click()
      this.SB.new_v.order_unit.teams_each_shuffle()
      this.SB.al_share({label: "ﾁｰﾑ内ｼｬｯﾌﾙ", message: "ﾁｰﾑ内ｼｬｯﾌﾙしました"})
    },

    // 振り駒
    furigoma_handle() {
      if (this.order_unit_invalid()) { return }
      if (this.swap_invalid("振り駒")) { return }
      const furigoma_pack = FurigomaPack.call({
        furigoma_random_key: this.$route.query.furigoma_random_key,
        shakashaka_count: this.$route.query.shakashaka_count,
      })
      const prefix = `振り駒をした結果、${furigoma_pack.message}`
      this.sfx_click()
      this.SB.new_v.order_unit.furigoma_core(furigoma_pack.swap_p)
      const user = this.SB.new_v.order_unit.first_user(this.SB.start_color)
      GX.assert(user != null, "user != null")
      const message = `${prefix}で${this.user_call_name(user.user_name)}の先手になりました`
      this.SB.al_share({label: furigoma_pack.piece_names, message: message})
    },

    // 先後入替
    swap_handle() {
      if (this.swap_invalid("先後入替")) { return }
      this.sfx_click()
      this.SB.new_v.order_unit.swap_run()
      this.SB.al_share({label: "先後入替", message: "先後を入れ替えました"})
    },

    // 偶数人数であること
    swap_invalid(name) {
      if (!this.SB.new_v.order_unit.swap_enable_p) {
        this.sfx_play("x")
        this.toast_warn(`参加人数が奇数のときはチーム編成が変わるので${name}できません`)
        return true
      }
    },

    os_before_apply() {
      // let v = this.SB.new_v.change_per
      // v = GX.to_i(v)
      // if (v <= 0) {
      //   v = 1
      // }
      // this.SB.new_v.change_per = v
    },

    // 反映時のエラーの内容は new_v.order_unit に任せる
    order_unit_invalid() {
      const messages = this.SB.new_v.order_unit.error_messages
      if (GX.present_p(messages)) {
        this.sfx_play("x")
        messages.forEach(e => this.toast_warn(e))
        return true
      }
    },

    options_invalid() {
      if (GX.blank_p(this.SB.new_v.change_per)) {
        this.sfx_play("x")
        this.toast_warn("「X回指したら交代する」の項目を正しく入力してください")
        return true
      }
    },

    // 反映
    apply_handle() {
      this.os_before_apply()
      if (this.order_unit_invalid()) { return }
      if (this.options_invalid()) { return }
      this.sfx_click()
      if (!this.SB.new_v.os_change.has_changes_to_save_p) {
        this.toast_ok(`変更はありません`)
        return
      }
      this.SB.new_order_share("順番設定を反映しました")
      this.$GX.delay_block(this.__SYSTEM_TEST_RUNNING__ ? 0 : 3.0, () => this.SB.cc_next_message())
    },

    // バリデーションなしで反映する
    os_modal_force_submit_handle() {
      this.os_before_apply()
      if (this.options_invalid()) { return }
      this.SB.new_order_share("バリデーションなしで順番設定を反映しました")
    },

    option_block_show_handle() {
      this.sfx_click()
      this.option_block_show_p = true
    },

    hint_handle(model) {
      this.sfx_stop_all()
      this.sfx_click()
      this.toast_ok(model.hint_messages.join(""), {duration: 1000 * 7})
    },

    state_toggle_handle() {
      this.sfx_click()
      this.SB.new_v.order_unit.state_toggle()
    },

    ////////////////////////////////////////////////////////////////////////////////

    quiz_maker_handle() {
      this.sfx_click()
      this.SB.os_modal_close()
      this.SB.quiz_maker_handle()
      this.SB.al_share({label: "お題作成", message: "お題を作成しています"})
    },

    voted_result_to_order_apply_handle() {
      this.sfx_click()
      this.SB.voted_result_to_order_apply()
      this.SB.al_share({label: "結果反映", message: "投票の結果でチーム分けしました"})
    },

    quiz_delete_handle() {
      this.sfx_click()
      this.SB.quiz_delete()
      this.SB.al_share({label: "お題削除", message: "お題を削除しました"})
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    submit_button_color() {
      if (this.SB.new_v.order_unit.invalid_p) {
        return "is-warning"
      }
      if (this.SB.new_v.os_change.has_changes_to_save_p) {
        return "is-primary"
      }
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.OrderSettingModal
  +modal_width(480px)
  // +modal_width_auto

  .TeamsContainer
    // width: 12rem
    // width: 100%
    display: flex // OrderTeamOne を横並び化
    justify-content: center
    gap: 6px

  .shuffle_buttons
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

.STAGE-development
  .OrderSettingModal
    .modal-card-body
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .start_message
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .TeamsContainer
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .shuffle_buttons
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
