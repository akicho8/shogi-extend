
/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker')

import "bootstrap-honoka/dist/css/bootstrap.min.css"
import "bootstrap-honoka/dist/js/bootstrap.min.js"

import "./modulable_crud.coffee"

import "./basic.sass"
import "./bootstrap_tuning.sass"

// require("bootstrap/dist/css/bootstrap")
// require("bootstrap/dist/css/bootstrap-theme")

console.log(`jQuery ${typeof(jQuery)}`)

document.addEventListener("DOMContentLoaded", () => {
  const buttons = document.querySelectorAll(".kif_clipboard_copy_button")
  for (var i = 0, len = buttons.length; i < len; i++) {
    buttons[i].addEventListener("click", function(e) {

      const url = e.target.dataset.kifDirectAccessPath // kif_direct_access_path

      if (!url) {
        alert("URLが取得できません")
      }

      // ユーザーがクリックしたタイミングでないとクリップボードにコピーできないため同期している
      const kifu_text = $.ajax({type: "GET", url: url, async: false}).responseText

      const text_area = document.createElement("textarea")
      text_area.value = kifu_text
      document.body.appendChild(text_area)
      text_area.select()
      const result = document.execCommand("copy")
      document.body.removeChild(text_area)
      if (result) {
        alert("クリップボードにコピーしました")
      } else {
        alert("クリップボードへのコピーに失敗しました")
      }

      e.preventDefault()

    })
  }

  // $(".kif_clipboard_copy_button").click()

})
