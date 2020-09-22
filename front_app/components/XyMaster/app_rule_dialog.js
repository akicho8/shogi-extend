export const app_rule_dialog = {
  methods: {
    rule_display() {
      this.talk_stop()
      this.sound_play("click")

      const rule_dialog = this.$buefy.dialog.alert({
        title: "ルール",
        message: `
          <div class="content is-size-7">
            <ol>
              <li>TAPモードでは符号に対応する位置をタップします</li>
              <li>TAPじゃないモードでは駒の場所をキーボードの数字2桁で入力していきます。最初の数字を間違えたときはESCキーでキャンセルできます</li>
              <li>選択した数まで正解するまでの時間を競います</li>
              <li>ログインしていると毎回出る名前の入力を省略できます</li>
            </ol>
          </div>`,
        confirmText: "わかった",
        canCancel: ["outside", "escape"],
        type: "is-info",
        hasIcon: true,
        trapFocus: true,
        onConfirm: () => {
          this.talk_stop()
          this.sound_play("click")
        },
        onCancel:  () => {
          this.talk_stop()
          this.sound_play("click")
        },
      })

      this.talk(`
        タップモードでは符号に対応する位置をタップします。
        タップじゃないモードでは駒の場所をキーボードの数字2桁で入力していきます。最初の数字を間違えたときはエスケープキーでキャンセルできます。
        選択した数まで正解するまでの時間を競います。
        ログインしていると毎回出る名前の入力を省略できます。`, {rate: 2.0, onend: () => rule_dialog.close()})
    },
  },
}
