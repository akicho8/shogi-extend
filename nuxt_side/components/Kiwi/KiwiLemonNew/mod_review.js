import { ValidationInfo } from "../models/validation_info.js"
import _ from "lodash"

export const mod_review = {
  data() {
    return {
      done_record: null,        // 変換が完了した状態のレコード
    }
  },
  methods: {
    close_handle() {
      this.sfx_click()
      this.posted_record = null
      this.done_record = null
    },

    banana_new_handle(record) {
      this.sfx_click()

      if (this.$gs.present_p(record.banana)) {
        this.talk("ライブラリ登録済みです。編集ページに移動しますか？")
        this.dialog_confirm({
          title: "ライブラリ登録済みです",
          message: "編集ページに移動しますか？",
          confirmText: "移動する",
          onConfirm: () => {
            this.sfx_click()
            this.$router.push({name: 'video-studio-banana_key-edit', params: {banana_key: record.banana.key}})
          },
        })
      } else {
        this.talk("登録しますか？")
        this.dialog_confirm({
          title: "ライブラリに登録しますか？",
          message: `
          <div class="content">
            <p class="is-size-7">登録したらできること:</p>
            <ol class="mt-0">
              <li>専用ページの作成</li>
              <li>タイトルや説明の追加</li>
              <li>みんなに公開</li>
              <li>仲間内だけで共有</li>
              <li>自分だけでこっそり見返す</li>
            </ol>
          </div>
        `,
          // <p>作成直後のファイルをダウンロードするだけなら不要です</p>
          confirmText: "登録する",
          cancelText: "しない",
          onConfirm: () => {
            this.sfx_click()
            this.$router.push({name: "video-studio-new", query: {source_id: record.id}})
          },
        })
      }
    },

    banana_show_handle(record) {
      this.sfx_click()
      this.$gs.assert(record.banana, "record.banana")
      this.$router.push({name: 'video-watch-banana_key', params: {banana_key: record.banana.key}})
    },

    download_talk_handle() {
      this.sfx_click()
      this.$gs.delay_block(1, () => this.talk("ダウンロードしました"))
    },

    rails_attachment_show_handle(record) {
      this.sfx_click()
      window.location.href = record.rails_side_download_url
    },

    rails_inline_show_test_handle(record) {
      this.sfx_click()
      this.window_popup(record.rails_side_inline_url, record.to_wh)
    },

    json_show_handle(record) {
      this.sfx_click()
      this.other_window_open(record.rails_side_json_url)
    },

    retry_run_handle(record) {
      this.sfx_click()
      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/kiwi/lemons/retry_run.json", {id: record.id}).then(e => this.success_proc(e)).finally(() => {
        loading.close()
      })
    },

    destroy_run_handle(record) {
      this.sfx_click()
      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/kiwi/lemons/destroy_run.json", {id: record.id}).then(e => this.success_proc(e)).finally(() => {
        loading.close()
      })
    },

    load_handle(record) {
      this.sfx_click()
      this.done_record = record
    },

    // 未使用
    __other_window_open_handle(record) {
      this.sfx_click()
      this.window_popup(record.browser_path, record.to_wh)
    },

    other_window_open_if_pc_handle(record) {
      this.sfx_click()
      this.url_open(record.browser_path, this.target_default)
    },
  },
  computed: {
    review_error_messages() {
      const list = []
      if (this.done_record) {
        if (this.done_record.successed_at) {
          if (this.done_record.recipe_info.media_p) {
            ValidationInfo.values.forEach(e => {
              if (e.environment == null || e.environment.includes(this.$config.STAGE)) {
                const valid_p = e.validate(this, this.done_record)
                if (valid_p != null) {
                  const item = {
                    valid_p: valid_p,
                    should_be: e.should_be(this),
                    human_value: e.human_value(this, this.done_record),
                  }
                  if (valid_p) {
                    item.icon_args = { icon: "check", type: "is-success" }
                  } else {
                    item.icon_args = e.icon_args
                  }
                  list.push(item)
                }
              }
            })
          }
        }
      }
      // return this.$gs.presence(list.flat())
      return list
    },

    review_error_messages_valid_p() {
      return this.review_error_messages.every(e => e.valid_p)
    }
  },
}
