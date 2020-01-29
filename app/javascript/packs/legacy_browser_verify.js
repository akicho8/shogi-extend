if (window.navigator.userAgent.match(/Windows.*Edge/)) {
  alert("ブラウザが古いため表示できません\n外部サイトに移動しますので新しい Microsoft Edge に更新してください\nもしくは Google Chrome をご利用ください")
  location.href = "https://www.microsoft.com/en-us/edge"
} else if (window.navigator.userAgent.match(/Chrome\/7[678]\./) && false) {
  if (window.navigator.userAgent.match(/Android/)) {
    alert("ブラウザが古いため動作しないかもしれません\n端末に向かって「OK Google クローム 更新」と叫んでください")
  } else if (window.navigator.userAgent.match(/iPhone|iPad/)) {
    alert("ブラウザが古いため動作しないかもしれません\n端末に向かって「Hey Siri クローム 更新」と叫んでください")
  } else {
    alert("ブラウザが古いため動作しないかもしれません\nGoogle Chrome を更新してください")
    // if (window.confirm("ブラウザが古いため動作しないかもしれません\n新しい Google Chrome に更新しますか？")) {
    //   location.href = "https:support.google.com/chrome/answer/95414?co=GENIE.Platform%3DDesktop&hl=ja"
    // }
  }
}
