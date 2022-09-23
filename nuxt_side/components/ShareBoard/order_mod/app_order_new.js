// 順番設定モーダル用

import { OsChange } from "./os_change.js"
import { OrderUnit } from "./order_unit/order_unit.js"
import OrderSettingModal from "./OrderSettingModal.vue"

export const app_order_new = {
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
        os_change:         null, // OsChange のインスタンス
      },
    }
  },
  methods: {
    os_modal_handle() {
      if (this.if_room_is_empty()) { return }
      this.sidebar_p = false
      this.sound_play_click()
      this.os_modal_init()
      this.__assert__(this.os_modal_instance == null, "this.os_modal_instance == null")
      this.os_modal_instance = this.modal_card_open({
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

    // 順番設定モーダル内で使うデータの準備
    os_modal_init() {
      // 現在の順番設定をコピーする
      this.new_v.order_unit = this.order_unit.deep_clone()

      // オプション的なものもコピーする
      {
        this.new_v.move_guard_key    = this.move_guard_key
        this.new_v.avatar_king_key   = this.avatar_king_key
        this.new_v.shout_mode_key    = this.shout_mode_key
        this.new_v.foul_behavior_key = this.foul_behavior_key
        this.new_v.tegoto            = this.tegoto
      }

      // 変更記録用
      this.new_v.os_change = new OsChange(this.new_v)

      // 残りの観戦者をセットする(対局者は自動的に除く)
      this.new_v.order_unit.auto_users_set(this.room_user_names)
    },

    // 順番設定モーダルを閉じる
    // 別のところから強制的に閉じたいとき用
    os_modal_close() {
      if (this.os_modal_instance) {
        this.os_modal_instance.close()
        this.os_modal_instance = null
      }
    },

    // 閉じる
    os_modal_close_confirm(params = {}) {
      this.sound_play_click()
      this.talk("変更を適用せずに閉じようとしています")
      this.dialog_confirm({
        title: "ちょっと待って",
        type: "is-warning",
        hasIcon: true,
        message: this.new_v.os_change ? this.new_v.os_change.message : "(new_v.os_change undefined)",
        confirmText: "確定せずに閉じる",
        focusOn: "cancel",
        ...params,
      })
    },
  },
}
