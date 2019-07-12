// 主にフォームを便利するための機能
// ヘッダーが大きいと、フォームのエラー表示に気づかない場合があるため、エラーが出ているときだけ一気にそこまでスクロールする

document.addEventListener('DOMContentLoaded', () => {
  if (document.querySelector("a[name=form_errors]")) {
    document.location = "#form_errors"
  }
})

