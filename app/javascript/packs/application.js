/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker')

import "./bootstrap_basic.sass"
import "./bootstrap_tuning.sass"

import "bootstrap-honoka/dist/css/bootstrap.min.css"
import "bootstrap-honoka/dist/js/bootstrap.min.js"

// require("bootstrap/dist/css/bootstrap")
// require("bootstrap/dist/css/bootstrap-theme")

import "./modulable_crud.coffee"

console.log(`jQuery in webpacker: ${typeof(jQuery)}`)

document.addEventListener("DOMContentLoaded", () => {
  $('[data-toggle="tooltip"]').tooltip()

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
