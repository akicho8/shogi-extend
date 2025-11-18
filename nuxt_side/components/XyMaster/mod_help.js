const DIALOG_MESSAGE = `
 <div class="content is-size-7">
   <ol class="mt-0">
     <li>符号に対応する位置をタップします</li>
     <li>100問正解するまでの時間を競います</li>
     <li>ログインしていると毎回出る名前の入力を省略できます</li>
     <li>TAPじゃないモードはPC用で駒の場所をキーボードの数字2桁で入力していきます。最初の数字を間違えたときはESCキーでキャンセルできます</li>
   </ol>
 </div>`

const TALK_MESSAGE = `
符号に対応する位置をタップします。
100問正解するまでの時間を競います。
ログインしていると毎回出る名前の入力を省略できます。
タップじゃないモードはPC用で駒の場所をキーボードの数字2桁で入力していきます。最初の数字を間違えたときはエスケープキーでキャンセルできます。
`

export const mod_help = {
  methods: {
    async help_dialog_show() {
      this.help_dialog_cancel_process()

      const help_dialog_instance = this.dialog_alert({
        title: "ルール",
        message: DIALOG_MESSAGE,
        confirmText: "わかった",
        type: "is-info",
        onConfirm: () => this.help_dialog_cancel_process(),
        onCancel:  () => this.help_dialog_cancel_process(),
      })

      await this.talk(TALK_MESSAGE, {validate_length: false, rate: 2.0})
      help_dialog_instance.close()
    },

    // private

    help_dialog_cancel_process() {
      this.sfx_stop_all()
      this.sfx_click()
    },
  },
}
