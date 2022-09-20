<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 順番設定

      template(v-if="base.order_enable_p && false")
        span.ml-1.has-text-grey.has-text-weight-normal
          | 参加者{{base.new_v.order_unit.user_total_count}}人

    // footer の close_handle は位置がずれて Capybara (spec/system/share_board_spec.rb) で押せないため上にもう1つ設置
    a.mx-2.close_handle_for_capybara.delete(@click="close_handle" v-if="development_p")
    //- template(v-if="!instance")
    b-switch.main_switch(size="is-small" type="is-primary" v-model="base.order_enable_p" @input="main_switch_handle") 有効
  .modal-card-body
    .description(v-if="!base.order_enable_p")
      .has-text-centered.has-text-grey.my-6
        | 右上のスイッチで有効にしよう
    template(v-if="base.order_enable_p")
      OrderSettingModalTable(:base="base")
      .buttons.is-centered.mb-0.mt-4
        b-button.mb-0.shuffle_handle(@click="shuffle_handle" size="is-small") シャッフル
        b-button.mb-0.furigoma_handle(@click="furigoma_handle" size="is-small") 振り駒
        b-button.mb-0.swap_handle(@click="swap_handle" size="is-small") 先後入替
      hr
      .mt-3
        .columns.is-mobile.other_setting
          .column.is-flex.is-justify-content-center
            SimpleRadioButtons.foul_behavior(:base="base" custom-class="is-small" element_size="is-small" model_name="FoulBehaviorInfo" :my_value.sync="base.new_v.foul_behavior_key" @user_input="user_input_handle")
          .column.is-flex.is-justify-content-center(v-if="base.debug_mode_p && false")
            SimpleRadioButtons.avatar_king(:base="base" custom-class="is-small" element_size="is-small" model_name="AvatarKingInfo" :my_value.sync="base.new_v.avatar_king_key" @user_input="user_input_handle")
          .column.is-flex.is-justify-content-center(v-if="base.debug_mode_p && false")
            SimpleRadioButtons.shout_mode(:base="base" custom-class="is-small" element_size="is-small" model_name="ShoutModeInfo" :my_value.sync="base.new_v.shout_mode_key" @user_input="user_input_handle")
          .column.is-flex.is-justify-content-center(v-if="base.debug_mode_p && false")
            SimpleRadioButtons.tegoto(:base="base" custom-class="is-small" element_size="is-small" model_name="TegotoInfo" :my_value.sync="base.new_v.tegoto" @user_input="user_input_handle")
        .columns.is-mobile.other_setting(v-if="development_p && false")
          .column.is-flex.is-justify-content-center
            SimpleRadioButtons.move_guard(:base="base" custom-class="is-small" element_size="is-small" model_name="MoveGuardInfo" :my_value.sync="base.new_v.move_guard_key" @user_input="user_input_handle")

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 閉じる
    template(v-if="base.order_enable_p")
      b-button.apply_button(@click="apply_handle" :type="kakutei_type") 確定
</template>

<script>
const SHUFFLE_MAX = 8

import { support_child } from "../support_child.js"
import { Gs2           } from "@/components/models/gs2.js"
import { FurigomaPack  } from "@/components/models/furigoma_pack.js"
import { Location      } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "OrderSettingModal",
  mixins: [support_child],
  provide() {
    return {
      TheOSM: this,
    }
  },
  beforeMount() {
    this.base.os_modal_vars_setup()
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// イベント

    main_switch_handle(v) {
      this.sound_play_toggle(v)
      this.base.order_switch_share({order_enable_p: v, message: v ? "有効" : "無効"})

      // 一番最初に有効にしたときは1度反映を押した状態にする
      // 余計な世話になっているかもしれないので状況を見て無効にするかもしれない
      if (v) {
        if (this.base.order_unit == null) { // null ではなく、空だったら、とする
          this.base.new_order_share("")
        }
      }
    },

    close_handle() {
      if (this.base.os_modal_close_if_not_save_p) {
        this.base.os_modal_close_confirm({
          onConfirm: () => {
            this.sound_play_click()
            this.direct_close_handle()
          },
        })
        return
      }
      this.sound_play_click()
      this.direct_close_handle()
    },

    direct_close_handle() {
      this.$emit("close")
      this.base.os_modal_close()
    },

    test_handle() {
      this.sound_play_click()
      this.base.tn_notify()
    },

    // シャッフル
    shuffle_handle() {
      this.sound_play_click()
      this.base.new_v.order_unit.shuffle_core()
      this.base.shared_al_add({label: "シャッフル", message: "シャッフルしました"})
      this.base.os_change.append("順番")
    },

    // 振り駒
    furigoma_handle() {
      if (this.invalid_case2("振り駒")) { return }
      const furigoma_pack = FurigomaPack.run({
        furigoma_random_key: this.$route.query.furigoma_random_key,
        shakashaka_count: this.$route.query.shakashaka_count,
      })
      const prefix = `振り駒をした結果、${furigoma_pack.message}`
      this.sound_play_click()
      this.base.new_v.order_unit.furigoma_core(furigoma_pack.swap_p)
      const user = this.base.new_v.order_unit.first_user(this.base.start_color)
      Gs2.__assert__(user != null, "user != null")
      const message = `${prefix}で${this.user_call_name(user.user_name)}の先手になりました`
      this.base.shared_al_add({label: furigoma_pack.piece_names, message: message})
      this.base.os_change.append("先後")
    },

    // 先後入替
    swap_handle() {
      if (this.invalid_case2("先後入替")) { return }
      this.sound_play_click()
      this.base.new_v.order_unit.swap_run()
      this.base.shared_al_add({label: "先後入替", message: "先後を入れ替えました"})
      this.base.os_change.append("先後")
    },

    // 反映時のエラーの内容は new_v.order_unit に任せる
    invalid_case1() {
      const messages = this.base.new_v.order_unit.error_messages
      if (Gs2.present_p(messages)) {
        this.sound_play("x")
        messages.forEach(e => this.toast_warn(e))
        return true
      }
    },

    // 偶数人数であること
    invalid_case2(name) {
      if (!this.base.new_v.order_unit.irekae_can_p) {
        this.sound_play("x")
        this.toast_warn(`参加人数が奇数のときはチーム編成が変わるので${name}できません`)
        return true
      }
    },

    user_input_handle(model) {
      this.base.os_change.append(model.field_label)
    },

    // 反映
    apply_handle() {
      if (this.invalid_case1()) { return }
      this.sound_play_click()
      this.base.new_order_share("反映")
      this.base.os_change.clear()
      this.delay_block(this.$route.query.__system_test_now__ ? 0 : 3.0, () => this.base.cc_next_message())
    },

    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////

    hint_handle(model) {
      this.sound_stop_all()
      this.sound_play_click()
      this.toast_ok(model.hint_messages.join(""), {duration: 1000 * 7})
    },

    state_toggle_handle() {
      this.sound_play_click()
      this.base.new_v.order_unit.state_toggle()
    },
  },
  computed: {
    kakutei_type() {
      if (this.base.new_v.order_unit.invalid_p) {
        return "is-warning"
      }
      if (this.base.os_change.has_value_p) {
        return "is-primary"
      }
    },
  },

}
</script>

<style lang="sass">
@import "../support.sass"
.OrderSettingModal
  +modal_width_auto

  .table
    td
      vertical-align: center

  .description
    max-width: 26rem
    p:not(:first-child)
      margin-top: 0.75rem

  // .enable_toggle_handle
  //   margin: unset // 右にラベルがある想定で margin-right があるため取る

  .other_setting
    label
      cursor: pointer

.STAGE-development
  .OrderSettingModal
    .modal-card-body
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
