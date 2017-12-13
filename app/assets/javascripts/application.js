//= require rails-ujs
//= require jquery
//= require bootstrap-sprockets
//= require_tree .

////////////////////////////////////////////////////////////////////////////////
if (typeof(jQuery) != "undefined") {
  console.log('[Sprockets]jQuery: OK')
  if (typeof($) != "undefined") {
    console.log('[Sprockets]$: OK')
    if (typeof($().tooltip) != "undefined") {
      console.log('[Sprockets]Bootstrap JS: OK')
    } else {
      console.log('[Sprockets]Bootstrap JS: Missing')
    }
  } else {
    console.log('[Sprockets]$: Missing')
  }
} else {
  console.log('[Sprockets]jQuery: Missing')
}
////////////////////////////////////////////////////////////////////////////////

document.addEventListener("DOMContentLoaded", () => {
  ////////////////////////////////////////////////////////////////////////////////

  // bootstrap-sprockets は sprockets 側にしか入っていないためこちらで書くこと
  $('[data-toggle="tooltip"]').tooltip()

  ////////////////////////////////////////////////////////////////////////////////

  const buttons = document.querySelectorAll(".kif_clipboard_copy_button")
  for (let i = 0; i < buttons.length; i++) {
    buttons[i].addEventListener("click", (e) => {
      const url = e.target.dataset.kifDirectAccessPath // kif_direct_access_path

      if (!url) {
        alert("棋譜のURLが不明です")
      }

      // クリックのタイミングしかクリップボードへのコピーは作動しないため同期している(重要)
      const kifu_text = $.ajax({type: "GET", url: url, async: false}).responseText

      // クリップボードにコピーする
      const text_area = document.createElement("textarea")
      text_area.value = kifu_text
      document.body.appendChild(text_area)
      text_area.select()
      const result = document.execCommand("copy")
      document.body.removeChild(text_area)

      if (result) {
        if (false) {
          alert("クリップボードにコピーしました")
        } else {
          $(e.target).tooltip({title: "クリップボードにコピーしました", trigger: "manual"})
          $(e.target).tooltip("show")
          setTimeout(() => $(e.target).tooltip("destroy"), 1000)
        }
      } else {
        alert("クリップボードへのコピーに失敗しました")
      }

      e.preventDefault()
    })
  }
})
