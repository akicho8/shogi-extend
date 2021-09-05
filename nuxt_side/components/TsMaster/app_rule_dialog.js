const DIALOG_MESSAGE = `
 <div class="content is-size-7">
   <ul>
     <li>規定の正解数になるまでの時間を競います</li>
     <li>後手視点の問題は先手玉を詰まします</li>
     <li>正解判定はないので合ってると思ったらNEXTを押して次に進んでください</li>
     <li>言いかえると駒を動かさなくていいので簡単なものは脳内で解く訓練にしてもよいです</li>
     <li>難しいものは駒を動かしながらやってみてください</li>
     <li>駒を動かしていて手順を間違えたら下のボタンで戻れます</li>
     <li>ログインしていると毎回出る名前の入力を省略できます</li>
     <li>問題はすべてやねうら王公式クリスマスプレゼント詰将棋500万問から出題しています</li>
   </ul>
 </div>`

const TALK_MESSAGE = `
規定の正解数になるまでの時間を競います。
後手視点の問題は先手ぎょくを詰まします。
正解判定はないので、合ってると思ったらNEXTを押して次に進んでください。
言いかえると、駒を動かさなくていいので、簡単なものは脳内で解く訓練にしてもよいです。
難しいものは駒を動かしながらやってみてください。
駒を動かしていて手順を間違えたら下のボタンで戻れます。
ログインしていると毎回出る名前の入力を省略できます。
問題はすべて、やねうら王、公式クリスマスプレゼント、詰将棋500万問から出題しています。
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
      this.sound_stop_all()
      this.sound_play("click")
    },
  },
}
