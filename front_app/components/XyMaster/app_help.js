const DIALOG_MESSAGE = `
 <div class="content is-size-7">
   <ol>
     <li>TAPモードでは符号に対応する位置をタップします</li>
     <li>TAPじゃないモードでは駒の場所をキーボードの数字2桁で入力していきます。最初の数字を間違えたときはESCキーでキャンセルできます</li>
     <li>選択した数まで正解するまでの時間を競います</li>
     <li>ログインしていると毎回出る名前の入力を省略できます</li>
   </ol>
 </div>`

const TALK_MESSAGE = `
タップモードでは符号に対応する位置をタップします。
タップじゃないモードでは駒の場所をキーボードの数字2桁で入力していきます。最初の数字を間違えたときはエスケープキーでキャンセルできます。
選択した数まで正解するまでの時間を競います。
ログインしていると毎回出る名前の入力を省略できます。
`

export const app_help = {
  methods: {
    help_dialog_show() {
      this.help_dialog_cancel_process()

      const help_dialog_instance = this.$buefy.dialog.alert({
        title: "ルール",
        message: DIALOG_MESSAGE,
        confirmText: "わかった",
        canCancel: ["outside", "escape"],
        type: "is-info",
        hasIcon: false,
        trapFocus: true,
        onConfirm: () => this.help_dialog_cancel_process(),
        onCancel:  () => this.help_dialog_cancel_process(),
      })

      this.talk(TALK_MESSAGE, {rate: 2.0, onend: () => help_dialog_instance.close()})
    },

    // private

    help_dialog_cancel_process() {
      this.sound_stop_all()
      this.sound_play("click")
    },
  },
}
