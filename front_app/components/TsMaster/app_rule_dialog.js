const DIALOG_MESSAGE = `
 <div class="content is-size-7">
   <ul>
     <li>規定の正解数に達するまでの時間を競います</li>
     <li>後手視点の問題は先手玉を詰まします</li>
     <li>正解の判定とかはないので合ってると思ったら次に進んでください</li>
     <li>別の見方をすれば駒を動かさなくていいのでひと目の3手詰などは脳内で解いてさくさく進めるなどしてください</li>
     <li>難しいものは駒を動かしながらやってみてください</li>
     <li>駒を動かしていて手順を間違えたら下のボタンで戻れます</li>
     <li>ログインしていると毎回出る名前の入力を省略できます</li>
     <li>問題はすべて<b>やねうら王公式クリスマスプレゼント詰将棋500万問</b>からランダムに出題しています</li>
   </ul>
 </div>`

const TALK_MESSAGE = `
規定の正解数に達するまでの時間を競います。
後手視点の問題は先手玉を詰まします。
正解の判定とかはないので合ってると思ったら次に進んでください。
別の見方をすれば駒を動かさなくていいので、ひと目の3手詰などは、脳内で解いてさくさく進めるなどしてください。
難しいものは駒を動かしながらやってみてください。
駒を動かしていて手順を間違えたら下のボタンで戻れます。
ログインしていると毎回出る名前の入力を省略できます。
問題はすべて、やねうら王公式クリスマスプレゼント詰将棋500万問からランダムに出題しています。
`

export const app_rule_dialog = {
  methods: {
    rule_dialog_show() {
      this.rule_dialog_cancel_process()

      const dialog = this.$buefy.dialog.alert({
        title: "ルールなど",
        message: DIALOG_MESSAGE,
        confirmText: "わかった",
        canCancel: ["outside", "escape"],
        type: "is-info",
        hasIcon: false,
        trapFocus: true,
        onConfirm: () => this.rule_dialog_cancel_process(),
        onCancel:  () => this.rule_dialog_cancel_process(),
      })

      this.talk(TALK_MESSAGE, {rate: 2.0, onend: () => dialog.close()})
    },

    // private

    rule_dialog_cancel_process() {
      this.talk_stop()
      this.sound_play("click")
    },
  },
}
