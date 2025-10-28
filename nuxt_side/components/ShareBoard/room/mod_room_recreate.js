import RoomRecreateModal from "./RoomRecreateModal.vue"
import { GX } from "@/components/models/gx.js"

const ROOM_DESTROY_AFTER_DELAY_SEC = 2.0 // 切断後に接続するまで待つ秒数(0にすると切断が終わる前に切断を開始して失敗する)

const APP_RELOAD_IF_RECREATE = false // 再起動するときリロードする？

export const mod_room_recreate = {
  data() {
    return {
      room_recreate_now: false,
      room_recreate_modal_instance: null,
    }
  },
  watch: {
    "$nuxt.isOnline"(is_online) {
      if (is_online) {
        this.internet_on_trigger()
      } else {
        this.internet_off_trigger()
      }
    },
  },
  beforeDestroy() {
    this.room_recreate_modal_close()
  },
  methods: {
    internet_on_trigger() {
      this.toast_ok("オンラインになりました")
      if (this.ac_room) {
        this.room_recreate_handle()
      }
    },
    internet_off_trigger() {
      this.toast_ng("オフラインになりました")
      if (this.ac_room) {
        this.room_recreate_modal_open_handle()
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_recreate_modal_open_handle() {
      if (!this.room_recreate_modal_instance) {
        this.sfx_click()
        this.room_recreate_modal_open()
      }
    },
    room_recreate_modal_open() {
      if (!this.room_recreate_modal_instance) {
        // https://buefy.org/documentation/modal
        this.room_recreate_modal_instance = this.modal_card_open({
          component: RoomRecreateModal,
          canCancel: [],
          // onCancel: () => {
          //   this.sfx_click()
          //   this.room_recreate_modal_close()
          // },
        })
      }
    },
    room_recreate_modal_close_handle() {
      if (this.room_recreate_modal_instance) {
        this.sfx_click()
        this.room_recreate_modal_close()
      }
    },
    room_recreate_modal_close() {
      if (this.room_recreate_modal_instance) {
        this.room_recreate_modal_instance.close()
        this.room_recreate_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_recreate_handle() {
      this.room_recreate_modal_close()
      this.room_recreate()
    },

    // ac_room.unsubscribe() をした直後に subscribe すると subscribe が無効になる
    // なので少し待ってから実行する
    async room_recreate() {
      if (this.ac_room && !this.room_recreate_now) {
        this.room_recreate_now = true
        this.toast_ok("復帰中です", {talk: false})
        this.room_destroy()
        const loading = this.$buefy.loading.open()
        await GX.sleep(this.ROOM_DESTROY_AFTER_DELAY_SEC)
        if (APP_RELOAD_IF_RECREATE) {
          this.force_reload()
          return
        }
        this.room_create()
        loading.close()
        this.toast_ok("復帰しました")
        this.ac_log({subject: "通信回復", body: "入室→オフライン→オンライン→入室"})
        this.room_recreate_now = false
      }
    },
  },
  computed: {
    ROOM_DESTROY_AFTER_DELAY_SEC() { return this.$route.query.ROOM_DESTROY_AFTER_DELAY_SEC || ROOM_DESTROY_AFTER_DELAY_SEC },
  },
}
