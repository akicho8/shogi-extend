export default {
  methods: {
    process_now() {
      this.$loading.open()
    },

    js_link_to(href) {
      this.process_now()
      location.href = href
    },

    wars_tweet_copy_click(wars_tweet_body) {
      this.clipboard_copy({text: wars_tweet_body})
    },

    kifu_copy_exec_click(e) {
      const params = JSON.parse(e.target.dataset[_.camelCase("kifu_copy_params")])
      this.kifu_copy_exec(params)
    },

    debug_alert(message) {
      if (process.env.NODE_ENV === "development") {
        this.$toast.open({message: message, position: "is-bottom", type: "is-danger"})
      }
    },

    // 指定 URL の結果をクリップボードにコピー
    kifu_copy_exec(params) {
      params = Object.assign({}, {
        success_message: "棋譜をクリップボードにコピーしました",
      }, params)

      const kc_url = params["kc_url"]
      const kc_title = params["kc_title"]
      if (kc_title) {
        params["success_yomiage"] = `${kc_title}の棋譜をクリップボードにコピーしました`
      }

      if (kc_url) {
        const kc_format = params["kc_format"] || "kif"
        const full_url = `${kc_url}.${kc_format}`

        if (true) {
          this.$http.get(full_url, { params: { copy_trigger: true }}).then(response => {
            params["text"] = response.data
            this.clipboard_copy(params)
          }).catch(error => {
            console.table([error.response])
            this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
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
      params = Object.assign({}, {
        success_message: "クリップボードにコピーしました",
        error_message: "クリップボードへのコピーに失敗しました",
        success_yomiage: "コピーしました",
        error_yomiage: "失敗しました",
      }, params)

      let success = null

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
          // this.talk(params["error_yomiage"])
          // this.$toast.open({message: params["error_message"], position: "is-bottom", type: "is-danger"})
          this.clipboard_copy_error_dialog(params)
          return
        }

        this.talk(params["success_yomiage"])
        this.$toast.open({message: params["success_message"], position: "is-bottom", type: "is-success"})
      }

      // この方法は Windows Chrome で必ず失敗するというか navigator.clipboard が定義されてないので激指をメインで使う人は異様に使いにくくなってしまう
      // https://alligator.io/js/async-clipboard-api/
      if (false) {
        if (navigator.clipboard) {
          navigator.clipboard.writeText(params["text"]).then(() => {
            this.talk(params["success_yomiage"])
            this.$toast.open({message: params["success_message"], position: "is-bottom", type: "is-success"})
          }).catch(err => {
            this.clipboard_copy_error_dialog(params)
          })
        } else {
          this.clipboard_copy_error_dialog(params)
        }
      }
    },

    clipboard_copy_error_dialog(params) {
      this.talk(params["error_yomiage"])
      // this.$toast.open({message: params["error_message"], position: "is-bottom", type: "is-danger"})

      this.$modal.open({
        parent: this,
        hasModalCard: true,
        component: {
          mounted() {
            this.$refs.text_copy_textarea.focus()
            this.$refs.text_copy_textarea.select()
          },
          template: `
<div class="modal-card" style="width: auto">
<header class="modal-card-head">
  <p class="modal-card-title">コピーに失敗しました</p>
</header>
<section class="modal-card-body">
  <p><small>こちらから手動でコピーしてみてください</small><p/>
  <b-field label="">
    <b-input type="textarea" value="${params['text']}" ref="text_copy_textarea"></b-input>
  </b-field>
</section>
<footer class="modal-card-foot">
  <button class="button" type="button" @click="$parent.close()">閉じる</button>
</footer>
</div>
    `,
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

    // ログイン強制
    login_required() {
      if (!js_global.current_user) {
        location.href = js_global.login_path
        return true
      }
    },

    // しゃべる
    talk(source_text) {
      // const params = new URLSearchParams()
      // params.set("source_text", source_text)
      // this.$http.post(js_global.talk_path, params).then(response => {
      this.$http.get(js_global.talk_path, {params: {source_text: source_text}}).then(response => {
        // すぐに発声する場合
        if (false) {
          const audio = new Audio()
          audio.src = response.data.service_path
          audio.play()
        }

        // 最後に来た音声のみ発声
        if (false) {
          if (!audio) {
            audio = new Audio()
          }
          audio.src = response.data.service_path
          audio.play()
        }

        // FIFO形式で順次発声
        if (true) {
          audio_queue.media_push(response.data.service_path)
        }

        // Howler
        if (false) {
          // new Howl({src: response.data.service_path, autoplay: true, volume: 1.0})
        }

      }).catch(error => {
        this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },
}
