
/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker')

// import SWFObject from "./swfobject.js"

// import "bootstrap-honoka/dist/css/bootstrap.min.css"
// import "bootstrap-honoka/dist/js/bootstrap.min.js"
import "./bootstrap_import.scss"
// import "bootstrap-sass/assets/javascripts/bootstrap.js"
import "bootstrap-sass"

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
        if (false) {
          alert("クリップボードにコピーしました")
        } else {
          $(e.target).tooltip({title: "クリップボードにコピーしました", trigger: "manual"})
          $(e.target).tooltip("show")
          setTimeout(() => $(e.target).tooltip("destroy"), 500)
        }
      } else {
        alert("クリップボードへのコピーに失敗しました")
      }

      e.preventDefault()

    })
  }

  // $(".kif_clipboard_copy_button").click()

  $('[data-toggle="tooltip"]').tooltip()

  // # animation: true          # フェイドイン・アウトするか？
  // # placement: "bottom"      # 表示場所
  // # title: "代替テキスト"    # title属性がない場合の代替テキスト
  // # trigger: "hover"         # 表示するタイミング
  // # delay: show:0, hide:100  # 表示までのディレイと消えるまでディレイ

})
