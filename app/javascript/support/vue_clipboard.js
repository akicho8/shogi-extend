export default {
  methods: {
    wars_tweet_copy_click(swars_tweet_text) {
      this.clipboard_copy({text: swars_tweet_text})
    },

    // Rails の通常のビューから使う用
    // とても使いにくい
    kifu_copy_exec_click(e) {
      const params = JSON.parse(e.target.dataset[_.camelCase("kifu_copy_params")])
      this.kifu_copy_exec(params)
    },

    // 指定 URL の結果をクリップボードにコピー
    // 引数の params を更新していって前回取得したテキストを保存し、2度目からはajaxしない
    kifu_copy_exec(params) {
      if (params.success_message == null) { params.success_message = "棋譜をクリップボードにコピーしました" }

      if (params["text"]) {
        this.debug_alert("パラメータにテキストが含まれる")
        this.clipboard_copy(params)
        return
      }

      const kc_url = params["kc_url"]
      const kc_title = params["kc_title"]
      if (kc_title && false) {
        params["success_yomiage"] = `${kc_title}の棋譜をクリップボードにコピーしました`
      }

      if (kc_url) {
        const kc_format = params["kc_format"] || "kif"
        const full_url = `${kc_url}.${kc_format}`

        if (true) {
          this.http_get_command(full_url, {}, data => {
            this.debug_alert("AJAX後にテキスト取得")
            params["text"] = data
            this.clipboard_copy(params)
          })
        } else {
          const kifu_text = $.ajax({ // このためだけに jQuery 使用
            type: "GET",
            url: `${full_url}?copy_trigger=true`,
            async: false, // 実際のクリックのタイミングでしかクリップボードへのコピーは作動しないという鬼仕様のため同期(重要)
          }).responseText
          params["text"] = kifu_text
          this.clipboard_copy(params)
        }
      }
    },

    // str をクリップボードにコピー
    clipboard_copy(params) {
      if (params.success_message == null) { params.success_message = "クリップボードにコピーしました"         }
      if (params.error_message == null)   { params.error_message   = "クリップボードへのコピーに失敗しました" }
      if (params.success_yomiage == null) { params.success_yomiage = "コピーしました"                         }
      if (params.error_yomiage == null)   { params.error_yomiage   = "失敗しました"                           }

      let success = false

      if (true) {
        // この方法は iPhone で動かない。先に elem.select() を実行した時点で iPhone の方が作動しなくなる
        if (false) {
          const elem = document.createElement("textarea")
          elem.value = params["text"]
          document.body.appendChild(elem)
          elem.select() // この方法は Windows Chrome でのみ動く
          success = document.execCommand("copy") // なんの嫌がらせか実際にクリックしていないと動作しないので注意
          console.log(`クリップボードコピー試行1: select => ${success}`)

          if (!success) {
            // この方法は iPhone と Mac の Chrome で動く。Mac の Safari では未検証
            const range = document.createRange()
            range.selectNode(elem)
            window.getSelection().addRange(range)
            success = document.execCommand("copy")
            console.log(`クリップボードコピー試行2: selectNode => ${success}`)
          }

          document.body.removeChild(elem)
        }

        // https://marmooo.blogspot.com/2018/02/javascript.html
        if (true) {
          const elem = document.createElement('textarea')
          document.body.appendChild(elem)
          elem.value = params["text"]
          success = this.corresponded_to_ios_pc_android_copy_to_clipboard(elem)
          document.body.removeChild(elem)
        }

        if (!success) {
          params.error_counter = (params.error_counter || 0) + 1
          if (params.error_dialog_enable) {
            this.clipboard_copy_error_dialog(params)
          } else {
            if (params.error_counter == 1) {
              this.talk("失敗しました。もう一度タップしてみてください", {rate: 1.5})
              this.$buefy.toast.open({message: "失敗しました。もう一度タップしてみてください", position: "is-bottom", queue: false, type: "is-warning"})
            }
            if (params.error_counter >= 2) {
              this.talk("失敗しました。もう何回やってもだめそうです", {rate: 1.5})
              this.$buefy.toast.open({message: "失敗しました。もう何回やってもだめそうです", position: "is-bottom", queue: false, type: "is-danger"})
              this.clipboard_copy_error_dialog(params)
            }
          }
          return
        }

        this.talk(params["success_yomiage"], {rate: 1.5})
        this.$buefy.toast.open({message: params["success_message"], position: "is-bottom", queue: false, type: "is-info"})
      }

      // この方法は Windows Chrome で必ず失敗するというか navigator.clipboard が定義されてないので激指をメインで使う人は異様に使いにくくなってしまう
      // https://alligator.io/js/async-clipboard-api/
      if (false) {
        if (navigator.clipboard) {
          navigator.clipboard.writeText(params["text"]).then(() => {
            this.talk(params["success_yomiage"])
            this.$buefy.toast.open({message: params["success_message"], position: "is-bottom", queue: false, type: "is-success"})
          }).catch(err => {
            this.clipboard_copy_error_dialog(params)
          })
        } else {
          this.clipboard_copy_error_dialog(params)
        }
      }
    },

    clipboard_copy_error_dialog(params) {
      // this.talk(params["error_yomiage"], {rate: 2.0})
      // this.$buefy.toast.open({message: params["error_message"], position: "is-bottom", queue: false, type: "is-danger"})

      this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        fullScreen: false,
        component: {
          mounted() {
            const el = this.$refs.text_copy_textarea.$refs.textarea
            el.focus()
            el.select()
            el.scrollTop = 0
          },
          template: `
            <div class="modal-card">
              <header class="modal-card-head">
                <p class="modal-card-title">棋譜のコピーに失敗しました</p>
              </header>
              <section class="modal-card-body">
                <p><small>こちらから手動でコピーしてみてください</small></p>
                <b-field label="">
                  <b-input type="textarea" value="${params['text']}" ref="text_copy_textarea" rows="20" size="is-small"></b-input>
                </b-field>
              </section>
              <footer class="modal-card-foot">
                <button class="button" type="button" @click="$parent.close()">閉じる</button>
              </footer>
            </div>`,
        },
      })
    },

    // https://marmooo.blogspot.com/2018/02/javascript.html
    corresponded_to_ios_pc_android_copy_to_clipboard(el) {
      // resolve the element
      el = (typeof el === 'string') ? document.querySelector(el) : el

      // handle iOS as a special case
      if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
        // save current contentEditable/readOnly status
        const editable = el.contentEditable
        const readOnly = el.readOnly

        // convert to editable with readonly to stop iOS keyboard opening
        el.contentEditable = true
        el.readOnly = true

        // create a selectable range
        const range = document.createRange()
        range.selectNodeContents(el)

        // select the range
        const selection = window.getSelection()
        selection.removeAllRanges()
        selection.addRange(range)
        el.setSelectionRange(0, 999999)

        // restore contentEditable/readOnly to original state
        el.contentEditable = editable
        el.readOnly = readOnly
      } else {
        el.select()
      }

      // execute copy command
      return document.execCommand('copy')
    },
  },
}
