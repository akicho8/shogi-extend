export const vue_clipboard = {
  methods: {
    // params.text をクリップボードにコピー
    // params を破壊する
    // params をずっと保持していれば1,2度目で挙動がかわる(←かなり危険)
    // 成功したら true を返す
    clipboard_copy(text, params = {}) {
      const success_message  = "コピーしました"
      const failure_message1 = "iOSだけなぜか初回に失敗しやがるのでもう一回タップしてみてください"
      const failure_message2 = "失敗しました。もう何回やってもダメそうです"

      params.text = text

      let success = false

      if (true) {
        // この方法は iPhone で動かない。先に elem.select() を実行した時点で iPhone の方が作動しなくなる
        if (false) {
          const el = document.createElement("textarea")
          el.value = params.text
          document.body.appendChild(el)
          el.select() // この方法は Windows Chrome でのみ動く
          success = document.execCommand("copy") // なんの嫌がらせか実際にクリックしていないと動作しないので注意
          console.log(`クリップボードコピー試行1: select => ${success}`)

          if (!success) {
            // この方法は iPhone と Mac の Chrome で動く。Mac の Safari では未検証
            const range = document.createRange()
            range.selectNode(el)
            window.getSelection().addRange(range)
            success = document.execCommand("copy")
            console.log(`クリップボードコピー試行2: selectNode => ${success}`)
          }

          document.body.removeChild(el)
        }

        // https://marmooo.blogspot.com/2018/02/javascript.html
        if (true) {
          const el = document.createElement('textarea')
          document.body.appendChild(el)
          el.value = params.text
          success = this.corresponded_to_ios_pc_android_copy_to_clipboard(el)
          document.body.removeChild(el)
        }

        if (!success) {
          params.error_counter = (params.error_counter || 0) + 1
          if (params.error_dialog_enable) {
            this.clipboard_copy_error_dialog(params)
          } else {
            if (params.error_counter == 1) {
              this.talk(failure_message1)
              this.$buefy.toast.open({message: failure_message1, position: "is-bottom", queue: false, type: "is-warning"})
            }
            if (params.error_counter >= 2) {
              this.talk(failure_message2)
              this.$buefy.toast.open({message: failure_message2, position: "is-bottom", queue: false, type: "is-danger"})
              this.clipboard_copy_error_dialog(params)
            }
          }
          return false
        }

        this.toast_ok(params.success_message ?? success_message)
        return true
      }

      // この方法は Windows Chrome で必ず失敗するというか navigator.clipboard が定義されてないので激指をメインで使う人は異様に使いにくくなってしまう
      // https://alligator.io/js/async-clipboard-api/
      //
      // PC Safari, iOS Safari も対応してない
      // https://developer.mozilla.org/ja/docs/Web/API/Navigator/clipboard
      if (false) {
        if (navigator.clipboard) {
          navigator.clipboard.writeText(params.text).then(() => {
            this.talk(success_message)
            this.$buefy.toast.open({message: success_message, position: "is-bottom", queue: false, type: "is-success"})
          }).catch(err => {
            this.clipboard_copy_error_dialog(params)
          })
        } else {
          this.clipboard_copy_error_dialog(params)
        }
      }
    },

    clipboard_copy_error_dialog(params) {
      // this.talk(params["failure_message"], {rate: 2.0})
      // this.$buefy.toast.open({message: params["failure_message"], position: "is-bottom", queue: false, type: "is-danger"})

      this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        fullScreen: false,
        component: {
          mounted() {
            const el = this.$refs.text_copy_textarea.$refs.textarea
            el.focus({preventScroll: true})
            el.select()
            el.scrollTop = 0
          },
          template: `
            <div class="modal-card">
              <div class="modal-card-head">
                <p class="modal-card-title">棋譜のコピーに失敗しました</p>
              </div>
              <div class="modal-card-body">
                <p><small>こちらから手動でコピーしてみてください</small></p>
                <b-field label="">
                  <b-input type="textarea" value="${params['text']}" ref="text_copy_textarea" rows="20" size="is-small"></b-input>
                </b-field>
              </div>
              <div class="modal-card-foot">
                <button class="button" type="button" @click="$parent.close()">閉じる</button>
              </div>
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
