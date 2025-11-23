// 順番設定モーダル用

import { OsChange } from "./os_change.js"
import { OrderFlow } from "./order_flow/order_flow.js"
import OrderSettingModal from "./OrderSettingModal.vue"
import { GX } from "@/components/models/gx.js"

export const mod_order_new = {
  data() {
    return {
      // ローカルのモーダルで使うテンポラリ変数
      // 「適用」してはじめて実変数に反映する
      // order_draft は順番設定モーダル用という意味がわかりやすいようにしているだけで特別効果はない
      order_draft: {
        order_flow:                   null, // テーブル用(出走順の実配列にあとから参加した人や観戦の人を追加したテンポラリ)

        foul_mode_key:                null, // 反則をどうするか
        auto_resign_key:              null, // 投了のタイミング
        think_mark_receive_scope_key: null, // 思考印のスコープ
        change_per:                   null, // N手毎交代

        os_change:                    null, // OsChange のインスタンス
        os_dnd_count: 0, // ドラッグ中なら 1 以上
      },
    }
  },

  beforeDestroy() {
    this.os_modal_close()
  },

  methods: {
    os_modal_open_handle() {
      if (this.os_modal_instance == null) {
        if (this.room_is_empty_p()) { return }

        this.sidebar_close()
        this.sfx_click()

        this.os_modal_init()

        GX.assert(this.os_modal_instance == null, "this.os_modal_instance == null")
        // this.gate_modal_close()
        this.os_modal_instance = this.modal_card_open({
          component: OrderSettingModal,
          props: { },
          canCancel: [],
          // fullScreen: true, // 左右に余白ができるのと 100vh はスマホでおかしくなる
          onCancel: () => {
            GX.assert(false, "must not happen")
            this.sfx_click()
            this.os_modal_close()
          },
        })
      }
    },

    // 順番設定モーダル内で使うデータの準備
    os_modal_init() {
      // 現在の順番設定をコピーする
      this.order_draft.order_flow = this.order_flow.deep_clone()

      // オプション的なものもコピーする
      this.os_options_copy_a_to_b(this, this.order_draft)

      // 変更記録用
      this.order_draft.os_change = new OsChange(this.order_draft)

      // 残りの観戦者をセットする(対局者は自動的に除く・始めての場合は全員入れてシャッフルする)
      this.order_draft.order_flow.auto_users_set(this.room_user_names, {with_shuffle: this.shuffle_first})
    },
    os_options_copy_a_to_b(from, to) {
      GX.assert_kind_of_integer(from.change_per)

      to.foul_mode_key                = from.foul_mode_key
      to.auto_resign_key              = from.auto_resign_key
      to.think_mark_receive_scope_key = from.think_mark_receive_scope_key
      to.change_per                   = from.change_per
    },

    // 順番設定モーダルを閉じる
    // 別のところから強制的に閉じたいとき用
    os_modal_close() {
      if (this.os_modal_instance) {
        this.os_modal_instance.close()
        this.os_modal_instance = null
        this.debug_alert("OrderSettingModal close")
      }
    },

    // 閉じる
    os_modal_close_confirm(params = {}) {
      this.sfx_click()
      this.sb_talk("変更を適用せずに閉じようとしています")
      this.dialog_confirm({
        title: "ちょっと待って",
        type: "is-warning",
        hasIcon: true,
        message: this.order_draft.os_change ? this.order_draft.os_change.message : "(order_draft.os_change undefined)",
        confirmText: "確定せずに閉じる",
        focusOn: "cancel",
        ...params,
      })
    },

    // 反映ボタンを押したときに呼ぶ
    // 「順番設定(仮)」の値を全体送信する
    // 自分を含めて受信し「順番設定」を更新する
    // さらに「順番設定(仮)」も更新する
    order_draft_publish(message) {
      GX.assert(this.order_draft.order_flow, "this.order_draft.order_flow")
      const params = {
        order_flow: this.order_draft.order_flow.attributes,
        message: message,
      }
      this.os_options_copy_a_to_b(this.order_draft, params)
      this.ac_room_perform("order_draft_publish", params) // --> app/channels/share_board/room_channel.rb
    },
    order_draft_publish_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.tl_alert("order_draft_publish 自分→自分")
      } else {
        this.tl_alert("order_draft_publish 自分→他者")
      }
      if (GX.present_p(params.message)) {
        this.al_add({...params, label: "順番更新"})
      }

      // order_draft.order_flow のパラメータを order_flow に反映する
      this.order_copy_from_bc(params)

      this.think_mark_auto_set() // 順番設定反映後、自分の立場に応じてマークモードの初期値を自動で設定する

      // 順番設定モーダルを開いているかどうかに関係なくモーダルで使う変数を更新する
      // 新しくなった order_flow を order_draft.order_flow に反映する
      if (this.os_modal_update_ok) {
        this.os_modal_init()
      }

      // 自分を含めて閉じる
      if (this.auto_close_p) {
        if (this.os_modal_update_ok) {
          this.os_modal_close()
        }
      }

      // 再送モーダルが出ている人はどうしてよいか迷っているため自動で閉じる
      this.rs_modal_with_timer_close()

      if (params.message) {
        this.toast_primary(`${this.user_call_name(params.from_user_name)}が${params.message}`)
      }
    },

    // 特定の人を除外するショートカット
    os_member_delete(user_name) {
      this.clog(this.order_flow.flat_uniq_users)
      this.os_modal_init()                                                         // order_draft を準備する
      this.order_draft.order_flow.user_name_reject(user_name)                            // order_draft から次の人を除外する
      this.order_draft_publish(`順番設定から${this.user_call_name(user_name)}を外しました`) // order_draft を配って更新する
    },
  },
  computed: {
    os_modal_update_ok() { return this.order_draft.os_dnd_count === 0 }, // 更新してもよいか？(ドラッグ操作していない状態か？)
  },
}
