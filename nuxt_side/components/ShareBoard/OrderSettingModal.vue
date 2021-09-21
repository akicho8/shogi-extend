<template lang="pug">
.modal-card.OrderSettingModal(style="width:auto")
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    p.modal-card-title.is-size-5
      span.has-text-weight-bold
        | 順番設定

    // footer の close_handle は位置がずれて Capybara (spec/system/share_board_spec.rb) で押せないため上にもう1つ設置
    a.mx-2.close_button_for_capybara.delete(@click="close_handle" v-if="development_p")

    //- template(v-if="!instance")
    b-switch.main_switch(size="is-small" type="is-primary" v-model="base.order_func_p" @input="main_switch_handle") 有効

  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-body
    .description(v-if="!base.order_func_p")
      .has-text-centered.has-text-grey.my-6
        | 設定する場合は右上のスイッチを有効にしよう

      template(v-if="false")
        p
          | 設定すると次の2つが機能します
          .content.mb-0
            ol
              li 手番を知らせる
              li 手番の人だけが駒を動かせる
        p
          | 1対1のときは手番が明確なのであまり利点はありません

        p 対局後に<b>検討</b>するときは自由に駒を動かせたほうがよいので<b>無効</b>に戻してください

    template(v-if="base.order_func_p")
      b-table(
        :data="base.os_table_rows"
        :row-class="(row, index) => !row.enabled_p && 'x-has-background-white-ter'"
        :mobile-cards="false"
        )

        b-table-column(v-slot="{row}" field="order_index" label="順番" centered :width="1")
          template(v-if="row.order_index != null")
            | {{base.current_sfen_info.location_by_offset(row.order_index).name}}
            | {{row.order_index + 1}}

        b-table-column(v-slot="{row}" field="user_name" label="メンバー" cell-class="user_name")
          span(:class="{'has-text-weight-bold': row.order_index === base.order_index_by_turn(base.turn_offset)}")
            | {{row.user_name}}

        b-table-column(v-slot="{row}" field="enabled_p"   label="参加" centered)
          b-button.enable_toggle_handle(size="is-small" @click="enable_toggle_handle(row)" :type="{'is-primary': row.enabled_p}")
            template(v-if="row.enabled_p")
              | OK
            template(v-else)
              | 観戦

        b-table-column(v-slot="{row}" custom-key="operation" label="" :width="1" centered cell-class="px-1")
          template(v-if="row.enabled_p || true")
            b-button(     size="is-small" icon-left="arrow-up"   @click="arrow_handle(row,-1)")
            b-button.ml-1(size="is-small" icon-left="arrow-down" @click="arrow_handle(row, 1)")

      .buttons.mb-0.mt-2
        b-button.mb-0.shuffle_handle(@click="shuffle_handle" size="is-small") シャッフル

      hr

      .mt-3
        .columns.is-mobile
          .column
            b-field(label="アバター" custom-class="is-small" :message="base.AvatarKingInfo.fetch(base.new_avatar_king_key).message || base.AvatarKingInfo.message")
              b-field.is-marginless
                template(v-for="e in base.AvatarKingInfo.values")
                  b-radio-button(v-model="base.new_avatar_king_key" :native-value="e.key" size="is-small" @input="sound_play('click')")
                    | {{e.name}}
          .column
            b-field(label="シャウト" custom-class="is-small" :message="base.ShoutModeInfo.fetch(base.new_shout_mode_key).message || base.ShoutModeInfo.message")
              b-field.is-marginless
                template(v-for="e in base.ShoutModeInfo.values")
                  b-radio-button(v-model="base.new_shout_mode_key" :native-value="e.key" size="is-small" @input="sound_play('click')")
                    | {{e.name}}
        .columns.is-mobile(v-if="development_p && false")
          .column
            b-field(label="手番制限" custom-class="is-small" :message="base.MoveGuardInfo.fetch(base.new_move_guard_key).message")
              b-field.is-marginless
                template(v-for="e in base.MoveGuardInfo.values")
                  b-radio-button(v-model="base.new_move_guard_key" :native-value="e.key" size="is-small" @input="sound_play('click')")
                    | {{e.name}}

  .modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    template(v-if="base.order_func_p")
      b-button.test_button(@click="test_handle" v-if="development_p") テスト
      b-button.apply_button(@click="apply_handle" type="is-primary") 更新
</template>

<script>
const SHUFFLE_MAX = 8

import { support_child } from "./support_child.js"
import _ from "lodash"
import { CycleIterator } from "@/components/models/cycle_iterator.js"

export default {
  name: "OrderSettingModal",
  mixins: [
    support_child,
  ],
  beforeMount() {
    this.base.os_modal_vars_setup()
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// イベント

    main_switch_handle(v) {
      this.sound_play("click")
      this.base.order_func_share({order_func_p: v, message: v ? "有効" : "無効"})

      // 一番最初に有効にしたときは1度更新を押した状態にする
      if (v) {
        if (this.base.ordered_members == null) {
          this.form_params_share("")
        }
      }
    },

    close_handle() {
      this.sound_play("click")
      this.$emit("close")
      this.base.os_modal_close()
    },

    test_handle() {
      this.sound_play("click")
      this.base.tn_notify()
    },

    shuffle_handle() {
      this.sound_play("click")

      const rows = this.base.os_table_rows
      let a = rows.filter(e => e.enabled_p)
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

    apply_handle() {
      this.sound_play("click")
      this.form_params_share("更新")
    },

    // 上下矢印ボタン
    arrow_handle(row, sign) {
      this.sound_play("click")
      const index = this.base.os_table_rows.findIndex(e => e.user_name === row.user_name)
      this.base.os_table_rows = this.ary_move(this.base.os_table_rows, index, index + sign)
      this.order_index_update()
    },

    // 参加 or 不参加ボタン
    enable_toggle_handle(row) {
      this.sound_play("click")
      row.enabled_p = !row.enabled_p
      this.order_index_update()
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
        message: message,
      })
    },
  },

  computed: {
  },
}
</script>

<style lang="sass">
@import "support.sass"

.STAGE-development
  .OrderSettingModal
    .modal-card-body
      border: 1px dashed change_color($primary, $alpha: 0.5)

.OrderSettingModal
  .table
    td
      vertical-align: center

  .description
    max-width: 26rem
    p:not(:first-child)
      margin-top: 0.75rem

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold

  .enable_toggle_handle
    min-width: 4rem
</style>
