<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 順番設定

      template(v-if="base.order_enable_p")
        span.ml-1.has-text-grey.has-text-weight-normal
          | 参加者{{base.new_ordered_members.length}}人
        span.ml-1(v-if="base.new_ordered_members_odd_p")
          b-tooltip(label="奇数では1周で先後が変わる" position="is-right" size="is-small")
            b-icon(icon="alert" type="is-warning" size="is-small")

    // footer の close_handle は位置がずれて Capybara (spec/system/share_board_spec.rb) で押せないため上にもう1つ設置
    a.mx-2.close_handle_for_capybara.delete(@click="close_handle" v-if="development_p")
    //- template(v-if="!instance")
    b-switch.main_switch(size="is-small" type="is-primary" v-model="base.order_enable_p" @input="main_switch_handle") 有効
  .modal-card-body
    .description(v-if="!base.order_enable_p")
      .has-text-centered.has-text-grey.my-6
        | 右上のスイッチで有効にしよう

    template(v-if="base.order_enable_p")
      OrderSettingModalTable(:base="base" :order_setting_modal="order_setting_modal")

      //- b-table ではスマホで drag できない
      b-table(
        v-if="false"
        :data="base.os_table_rows"
        :row-class="(row, index) => !row.enabled_p && 'x-has-background-white-ter'"
        :mobile-cards="false"
        )

        b-table-column(v-slot="{row}" field="order_index" label="順番" centered :width="1")
          template(v-if="row.order_index != null")
            | {{base.current_sfen_info.location_by_offset(row.order_index).name}}
            | {{row.order_index + 1}}

        b-table-column(v-slot="{row}" field="user_name" label="メンバー" cell-class="user_name")
          span(:class="{'has-text-weight-bold': row.order_index === base.order_index_by_turn(base.current_turn)}")
            | {{row.user_name}}

        b-table-column(v-if="false" v-slot="{row}" field="enabled_p" label="参加" centered)
          b-button.enable_toggle_handle(size="is-small" @click="enable_toggle_handle(row)" :type="{'is-primary': row.enabled_p}")
            template(v-if="row.enabled_p")
              | OK
            template(v-else)
              | 観戦

        b-table-column(v-slot="{row}" field="enabled_p" label="参加" centered)
          b-switch.enable_toggle_handle(:value="row.enabled_p" @input="(value) => enable_toggle_handle(row, value)")

        b-table-column(v-slot="{row}" custom-key="operation" label="" :width="1" centered cell-class="px-1")
          template(v-if="row.enabled_p || true")
            b-button(     size="is-small" icon-left="arrow-up"   @click="arrow_handle(row,-1)")
            b-button.ml-1(size="is-small" icon-left="arrow-down" @click="arrow_handle(row, 1)")

      .buttons.mb-0.mt-2
        b-button.mb-0.shuffle_handle(  @click="shuffle_handle"  size="is-small" icon-left="shuffle") シャッフル
        b-button.mb-0.furigoma_handle( @click="furigoma_handle" size="is-small" icon-left="dice-3") 振り駒
        b-button.mb-0.swap_handle(     @click="swap_handle"     size="is-small" icon-left="swap-vertical") 先後反転

      hr

      .mt-3
        .columns.is-mobile
          .column
            b-field(custom-class="is-small" :message="base.AvatarKingInfo.fetch(base.new_avatar_king_key).message || base.AvatarKingInfo.message")
              template(#label)
                a.label_with_hint.avatar_king_hint_handle(@click.stop="hint_handle(base.AvatarKingInfo)")
                  | {{base.AvatarKingInfo.field_label}}
                  b-icon(icon="comment-question-outline" size="is-small" type="is-warning" )

              b-field.is-marginless
                template(v-for="e in base.AvatarKingInfo.values")
                  b-radio-button(v-model="base.new_avatar_king_key" :native-value="e.key" size="is-small" @input="new_avatar_king_key_change_handle")
                    | {{e.name}}

          .column(v-if="base.debug_mode_p")
            b-field(custom-class="is-small" :message="base.ShoutModeInfo.fetch(base.new_shout_mode_key).message || base.ShoutModeInfo.message")
              template(#label)
                a.label_with_hint.shout_hint_handle(@click.stop="hint_handle(base.ShoutModeInfo)")
                  | {{base.ShoutModeInfo.field_label}}
                  b-icon(icon="comment-question-outline" size="is-small" type="is-warning" )

              b-field.is-marginless
                template(v-for="e in base.ShoutModeInfo.values")
                  b-radio-button(v-model="base.new_shout_mode_key" :native-value="e.key" size="is-small" @input="new_shout_mode_key_change_handle")
                    | {{e.name}}

          .column(v-if="base.debug_mode_p || true")
            b-field(custom-class="is-small" :message="base.TwoPawnModeInfo.fetch(base.new_two_pawn_mode_key).message || base.TwoPawnModeInfo.message")
              template(#label)
                a.label_with_hint.two_pawn_hint_handle(@click.stop="hint_handle(base.TwoPawnModeInfo)")
                  | {{base.TwoPawnModeInfo.field_label}}
                  b-icon(icon="comment-question-outline" size="is-small" type="is-warning" )

              b-field.is-marginless
                template(v-for="e in base.TwoPawnModeInfo.values")
                  b-radio-button(v-model="base.new_two_pawn_mode_key" :native-value="e.key" size="is-small" @input="new_two_pawn_mode_key_change_handle")
                    | {{e.name}}

          .column(v-if="base.debug_mode_p")
            b-field(custom-class="is-small" message="")
              template(#label)
                a.label_with_hint.hand_every_n_hint_handle(@click.stop="hint_handle(base.EveryNInfo)")
                  | {{base.EveryNInfo.field_label}}
                  b-icon(icon="comment-question-outline" size="is-small" type="is-warning" )
              b-numberinput(size="is-small" controls-position="compact" v-model="base.new_hand_every_n" :min="1" :max="10" :exponential="true" @input="sound_play_click()")

        .columns.is-mobile(v-if="development_p && false")
          .column
            b-field(label="手番制限" custom-class="is-small" :message="base.MoveGuardInfo.fetch(base.new_move_guard_key).message")
              b-field.is-marginless
                template(v-for="e in base.MoveGuardInfo.values")
                  b-radio-button(v-model="base.new_move_guard_key" :native-value="e.key" size="is-small" @input="sound_play_click()")
                    | {{e.name}}

  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    template(v-if="base.order_enable_p")
      b-button.test_button(@click="test_handle" v-if="development_p") テスト
      b-button.apply_button(@click="apply_handle" :type="{'is-primary': base.os_change.has_value_p}") 更新
</template>

<script>
const SHUFFLE_MAX = 8

import { support_child } from "./support_child.js"
import _ from "lodash"
import { FurigomaPack } from "@/components/models/furigoma_pack.js"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "OrderSettingModal",
  mixins: [support_child],
  beforeMount() {
    this.base.os_modal_vars_setup()
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// イベント

    main_switch_handle(v) {
      this.sound_play_toggle(v)
      this.base.order_switch_share({order_enable_p: v, message: v ? "有効" : "無効"})

      // 一番最初に有効にしたときは1度更新を押した状態にする
      // 余計な世話になっているかもしれないので状況を見て無効にするかもしれない
      if (v) {
        if (this.base.ordered_members == null) {
          this.form_params_share("")
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
      this.shuffle_core()
      this.base.shared_al_add({label: "シャッフル", message: "シャッフルしました"})
      this.base.os_change.append("順番")
    },

    shuffle_core() {
      const rows = this.base.os_table_rows
      let a = rows.filter(e => e.enabled_p) // new_ordered_members と同じ
      let b = rows.filter(e => !e.enabled_p)
      for (let i = 0; i < SHUFFLE_MAX; i++) {
        const c = _.shuffle(a)
        if (!_.isEqual(c, a)) {
          this.base.os_table_rows = [...c, ...b]
          this.order_index_update()
          break
        }
      }
    },

    // 振り駒
    furigoma_handle() {
      // if (this.validate_present()) { return }
      // if (this.validate_members_even("振り駒")) { return }
      const furigoma_pack = FurigomaPack.run({
        furigoma_random_key: this.$route.query.furigoma_random_key,
        shakashaka_count: this.$route.query.shakashaka_count,
      })
      const prefix = `振り駒をした結果、${furigoma_pack.message}`
      if (this.blank_p(this.base.new_ordered_members)) {
        this.sound_play("x")
        this.toast_warn(`${prefix}でしたが誰も参加していませんでした`)
        return
      }
      if (this.base.new_ordered_members_odd_p) {
        this.sound_play("x")
        this.toast_warn(`${prefix}でしたが参加人数が奇数のときはチーム編成が変わるので無効です`)
        return
      }
      this.sound_play_click()
      if (furigoma_pack.swap_p) {
        this.swap_core()
      }
      const user_name = this.base.new_ordered_members[0].user_name
      const message = `${prefix}で${this.user_call_name(user_name)}の先手になりました`
      this.base.shared_al_add({label: furigoma_pack.piece_names, message: message})
      this.base.os_change.append("先後")
    },

    // 先後入替
    swap_handle() {
      // if (this.validate_present()) { return }
      if (this.validate_members_even("先後入替")) { return }
      this.sound_play_click()
      this.swap_core()
      this.base.shared_al_add({label: "先後入替", message: "先後を入れ替えました"})
      this.base.os_change.append("先後")
    },

    // 1人以上いること
    validate_present() {
      if (this.blank_p(this.base.new_ordered_members)) {
        this.sound_play("x")
        this.toast_warn(`誰も参加していません`)
        return true
      }
    },

    // 偶数人数であること
    validate_members_even(name) {
      if (this.base.new_ordered_members_odd_p) {
        this.sound_play("x")
        this.toast_warn(`参加人数が奇数のときはチーム編成が変わるので${name}できません`)
        return true
      }
    },

    // 先後入れ替え
    swap_core() {
      const rows = this.base.os_table_rows
      let a = rows.filter(e => e.enabled_p) // new_ordered_members と同じ
      let b = rows.filter(e => !e.enabled_p)
      let c = this.ruby_like_each_slice_to_a(a, 2).flatMap(e => this.safe_reverse(e))
      this.base.os_table_rows = [...c, ...b]
      this.order_index_update()
    },

    new_avatar_king_key_change_handle() {
      this.sound_play_click()
      this.base.os_change.append("アバター")
    },

    new_shout_mode_key_change_handle() {
      this.sound_play_click()
      this.base.os_change.append("シャウト")
    },

    new_two_pawn_mode_key_change_handle() {
      this.sound_play_click()
      this.base.os_change.append("二歩")
    },

    new_hand_every_n_change_handle() {
      this.sound_play_click()
      this.base.os_change.append("N手毎交代")
    },

    // 上下矢印ボタン
    arrow_handle(row, sign) {
      this.sound_play_click()
      const index = this.base.os_table_rows.findIndex(e => e.user_name === row.user_name)
      this.base.os_table_rows = this.ary_move(this.base.os_table_rows, index, index + sign)
      this.order_index_update()
      this.base.os_change.append("順番")
    },

    // 参加 or 不参加ボタン
    enable_toggle_handle(row, value) {
      this.sound_play_toggle(value)
      row.enabled_p = value
      this.order_index_update()
      this.base.os_change.append("参加")
    },

    // 更新
    apply_handle() {
      this.sound_play_click()
      this.form_params_share("更新")
      this.base.os_change.clear()
      this.delay_block(3.0, () => this.base.cc_next_message())
    },

    ////////////////////////////////////////////////////////////////////////////////

    order_index_update() {
      let index = 0
      this.base.os_table_rows.forEach(e => {
        if (e.enabled_p) {
          e.order_index = index
          index += 1
        } else {
          e.order_index = null
        }
      })
    },

    // フォームの内容を新しい値として配信
    // 自分も含めて受信して更新する
    form_params_share(message) {
      this.base.ordered_members_share({
        ordered_members: this.base.new_ordered_members,
        move_guard_key: this.base.new_move_guard_key,
        avatar_king_key: this.base.new_avatar_king_key,
        shout_mode_key: this.base.new_shout_mode_key,
        two_pawn_mode_key: this.base.new_two_pawn_mode_key,
        hand_every_n: this.base.new_hand_every_n,
        message: message,
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    hint_handle(model) {
      this.sound_stop_all()
      this.sound_play_click()
      this.toast_ok(model.hint_messages.join(""), {duration: 1000 * 7})
    },
  },
  computed: {
    order_setting_modal() { return this },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.OrderSettingModal
  +modal_width_auto

  .table
    td
      vertical-align: center

  .description
    max-width: 26rem
    p:not(:first-child)
      margin-top: 0.75rem

  .enable_toggle_handle
    margin: unset // 右にラベルがある想定で margin-right があるため取る

  .label_with_hint
    color: inherit

.STAGE-development
  .OrderSettingModal
    .modal-card-body
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
