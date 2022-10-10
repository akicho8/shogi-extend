// 順番設定モーダル用

import { OsChange } from "./os_change.js"
import { OrderUnit } from "./order_unit/order_unit.js"
import OrderSettingModal from "./OrderSettingModal.vue"

export const app_order_new = {
  data() {
    return {
      // ローカルのモーダルで使うテンポラリ変数
      // 「適用」してはじめて実変数に反映する
      // new_v は順番設定モーダル用という意味がわかりやすいようにしているだけで特別効果はない
      new_v: {
        order_unit:        null, // テーブル用(出走順の実配列にあとから参加した人や観戦の人を追加したテンポラリ)
        foul_behavior_key: null, // 反則をどうするか
        tegoto:            null, // N手毎交代
        os_change:         null, // OsChange のインスタンス
        os_dnd_count:         0, // ドラッグ中なら 1 以上
      },
    }
  },
  methods: {
    os_modal_handle() {
      // 動かしている途中で消すとエラーになる
      // this.delay_block(5, () => this.os_modal_close())

      if (this.if_room_is_empty()) { return }
      this.sidebar_p = false
      this.$sound.play_click()
      this.os_modal_init()
      this.__assert__(this.os_modal_instance == null, "this.os_modal_instance == null")
      this.os_modal_instance = this.modal_card_open({
        component: OrderSettingModal,
        props: { },
        canCancel: [],
        // fullScreen: true, // 左右に余白ができるのと 100vh はスマホでおかしくなる
        onCancel: () => {
          this.__assert__(false, "must not happen")
          this.$sound.play_click()
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
        this.new_v.foul_behavior_key = this.foul_behavior_key
        this.new_v.tegoto            = this.tegoto
      }

      // 変更記録用
      this.new_v.os_change = new OsChange(this.new_v)

      // 残りの観戦者をセットする(対局者は自動的に除く・始めての場合は全員入れてシャッフルする)
      this.new_v.order_unit.auto_users_set(this.room_user_names, {with_shuffle: this.shuffle_first})
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
      this.$sound.play_click()
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

    // 「順番設定(仮)」の値を全体送信する
    // 自分を含めて受信し「順番設定」を更新する
    // さらに「順番設定(仮)」も更新する
    new_order_share(message) {
      this.__assert__(this.new_v.order_unit, "this.new_v.order_unit")
      const params = {
        order_unit:        this.new_v.order_unit.attributes,
        //
        foul_behavior_key: this.new_v.foul_behavior_key,
        tegoto:            this.new_v.tegoto,
        //
        message:           message,
      }
      this.ac_room_perform("new_order_share", params) // --> app/channels/share_board/room_channel.rb
    },
    new_order_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.tl_alert("new_order_share 自分→自分")
      } else {
        this.tl_alert("new_order_share 自分→他者")
      }
      if (this.present_p(params.message)) {
        this.al_add({
          ...params,
          label: "順番更新",
          sfen: this.current_sfen, // FIXME: とる
          turn: this.current_turn,
        })
      }

      // new_v.order_unit のパラメータを order_unit に反映する
      this.order_copy_from_bc(params)

      // 順番設定モーダルを開いているかどうかに関係なくモーダルで使う変数を更新する
      // 新しくなった order_unit を new_v.order_unit に反映する
      if (this.os_modal_update_ok) {
        this.os_modal_init()
      }

      // 自分を含めて閉じる
      if (this.auto_close_p) {
        if (this.os_modal_update_ok) {
          this.os_modal_close()
        }
      }

      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が順番設定を${params.message}しました`)
      }

    },
  },
  computed: {
    os_modal_update_ok() { return this.new_v.os_dnd_count === 0 },
  },
}
