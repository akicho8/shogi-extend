import RoomRecreateModal from "./RoomRecreateModal.vue"
import { Gs } from "@/components/models/gs.js"

const ROOM_DESTROY_AFTER_DELAY_SEC = 3.0 // 切断後に接続するまで待つ秒数(0にすると切断が終わる前に切断を開始して失敗する)

const APP_RELOAD_IF_RECREATE = true // 再起動するときリロードする？

export const mod_room_recreate = {
  data() {
    return {
      room_creating_busy: 0, // 1以上なら接続を試みている最中
    }
  },

  methods: {
    // 再起動モーダル起動
    room_recreate_modal_handle() {
      if (this.room_is_empty_p()) { return }
      this.sidebar_p = false
      this.sfx_click()
      this.modal_card_open({
        component: RoomRecreateModal,
      })
    },

    // ac_room.unsubscribe() をした直後に subscribe すると subscribe が無効になる
    // なので少し待ってから実行する
    room_recreate() {
      if (this.room_creating_busy >= 1) {
        this.toast_ng("再起動実行中")
        return
      }
      if (this.ac_room) {
        this.room_destroy()
        this.room_creating_busy += 1
        const loading = this.$buefy.loading.open()
        // this.toast_ok("退室しました", {duration: this.ROOM_DESTROY_AFTER_DELAY_SEC * 1000})
        Gs.delay_block(this.ROOM_DESTROY_AFTER_DELAY_SEC, () => {
          if (APP_RELOAD_IF_RECREATE) {
            this.force_reload()
          } else {
            this.room_create()
            this.room_creating_busy = 0
            loading.close()
            // this.toast_ok("入室しました")
          }
        })
      } else {
        this.room_create()
      }
    },
  },
  computed: {
    ROOM_DESTROY_AFTER_DELAY_SEC() { return this.$route.query.ROOM_DESTROY_AFTER_DELAY_SEC || ROOM_DESTROY_AFTER_DELAY_SEC },
  },
}
