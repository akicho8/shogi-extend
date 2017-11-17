# 主にフォームを便利するための機能

# ヘッダーが大きいと、フォームのエラー表示に気づかない場合があるため、エラーが出ているときだけ一気にそこまでスクロールする
$ ->
  anchor = "form_errors"
  if $("a[name=#{anchor}]").length >= 1
    document.location = "##{anchor}"
