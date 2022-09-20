// フォームで動かす設定

import { OsChange } from "./os_change.js"
import { OrderUnit } from "./order_unit/order_unit.js"
import OrderSettingModal from "./OrderSettingModal.vue"

export const app_new_order = {
  data() {
    return {
      // ローカルのモーダルで使うテンポラリ変数
      // 「適用」してはじめて実変数に反映する
      new_v: {
        order_unit:        null, // テーブル用(出走順の実配列にあとから参加した人や観戦の人を追加したテンポラリ)
        move_guard_key:    null, // 手番制限
        avatar_king_key:   null, // アバター表示
        shout_mode_key:    null, // 叫びモード
        foul_behavior_key: null, // 反則をどうするか
        tegoto:            null, // N手毎交代
      },
      os_change: null, // OsChange のインスタンス
    }
  },
  created() {
  },
  methods: {
    // 順番設定モーダル内で使うデータの準備
    os_modal_vars_setup() {
      this.tl_alert("os_modal_vars_setup")

      this.new_order_unit_setup()

      this.new_v.move_guard_key    = this.move_guard_key
      this.new_v.avatar_king_key   = this.avatar_king_key
      this.new_v.shout_mode_key    = this.shout_mode_key
      this.new_v.foul_behavior_key = this.foul_behavior_key
      this.new_v.tegoto            = this.tegoto

      this.os_change = new OsChange()
    },

    new_order_unit_setup() {
      // 1. 順番設定を持っていればそれを複製する
      // 2. 順番設定を持っていなければ新規で既存メンバーたちを流し込む
      if (this.order_unit) {
        this.new_v.order_unit = this.order_unit.deep_clone()
      } else {
        this.new_v.order_unit = OrderUnit.create(this.os_table_rows_default)
      }
      // 観戦者の追加
      this.watch_users_add()
    },

    // 観戦者の追加
    // 独立して叩けるようにする
    watch_users_add() {
      this.new_v.order_unit.watch_users_add(this.name_uniq_member_infos)
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
  },
  computed: {
  },
}
