
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

// import "babel-regenerator-runtime"

// require("bootstrap/dist/css/bootstrap")
// require("bootstrap/dist/css/bootstrap-theme")

console.log(`jQuery ${typeof(jQuery)}`)

import copy from 'copy-to-clipboard'

// button.addEventListener('click', function () {
//   copy('This is some cool text')
// })

// import axios from 'axios';

// const copy = require('clipboard-copy');

// import Clipboard from "clipboard/dist/clipboard.min.js";

// import copy from 'copy-to-clip';

// copy('Text');

// copy('Text', {
//   debug: true,
//   message: 'Press #{key} to copy',
// });

document.addEventListener("DOMContentLoaded", () => {

  // // var clipboard = new Clipboard('.botan2', {
  // //   text: function(trigger) {
  //
  // var tottoku = "aaa"
  // axios.get("http://localhost:3000/wars_records/hanairobiyori-ispt-20171104_220810.kif")
  //         .then(response => {
  //         // alert("ajax success")
  //           copy("ok")
  //       })
  //       // copy(response.data)
  //
  //       // console.log(response.data);
  //       // console.log(response.status);
  //       // console.log(response.statusText);
  //       // console.log(response.headers);
  //       // console.log(response.config);
  //
  //       .catch(function(error) {
  //         alert("ajax error")
  //
  //         this.tottoku = error
  //       })
  //
  //     // return trigger.getAttribute('aria-label');
  //     // return "123";
  //     alert(`return ${tottoku}`);
  //
  //     return tottoku;
  //   }
  // });
  // clipboard.on('success', function(e) {
  //   console.log(e);
  // });
  // clipboard.on('error', function(e) {
  //   console.log(e);
  // });

  // new Clipboard('.botan');

  // new Clipboard('.botan', {
  //   text: function(trigger) {
  //     // return trigger.getAttribute('aria-label');
  //     alert("1");
  //     return "ok";
  //   }
  // });

  var elem = document.querySelector(".botan2")
  elem.addEventListener("click", function () {

    // ユーザーがクリックしたタイミングでないとクリップボードにコピーできないため同期している
    var kifu_text = $.ajax({
      type: "GET",
      url: "http://localhost:3000/wars_records/hanairobiyori-ispt-20171104_220810.kif",
      async: false,
    }).responseText;

    var text_area = document.createElement("textarea")
    text_area.value = kifu_text
    document.body.appendChild(text_area)
    text_area.select();
    var result = document.execCommand("copy")
    document.body.removeChild(text_area)
    console.log(result);
    
    
    // alert(text);
    
    
    // $.ajax
    // url: "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=1&output=json&q=" + encodeURIComponent(url) + "&callback=?"
    //       dataType: "json"
    //       success: (data) ->
    //         $.each data.responseData.feed.entries, (i, entry) ->
    //           published_date = new Date(entry.publishedDate)
    //           sub_title = "<small>#{published_date.toLocaleDateString()}</small>"
    //           tag.append("<h2><a href=\"#{entry.link}\" target=\"_blank\" >#{entry.title}</a> #{sub_title}</h2>");
    //           str = entry.content.replace(/(\s*<br>\s*)+/g, '')
    //           tag.append("<div class=\"alert-message block-message warning\">#{str}</div>")
    
    
    // // alert(elem.dataset.battleKey);
    //
    // // multilineContainer.textContent
    // // copyToClipboard("a")
    //

    
    // var kekka;
    // axios.get("http://localhost:3000/wars_records/hanairobiyori-ispt-20171104_220810.kif")
    //   .then(function(response) {
    // 
    // 
    //     // copy(response.data)
    // 
    //     // console.log(response.data);
    //     // console.log(response.status);
    //     // console.log(response.statusText);
    //     // console.log(response.headers);
    //     // console.log(response.config);
    // 
    //   })
    //   .catch(function(error) { kekka = error })

  })

  // document.querySelector("#multiline-text ~ .half button")
  // .addEventListener('click', function () {
  //   copyToClipboard(multilineContainer.textContent)
  // })

})

// `copy(text: string, options: object): boolean` &mdash; tries to copy text to clipboard. Returns `true` if no additional keystrokes were required from user (so, `execCommand`, IE's `clipboardData` worked) or `false`.

  // <script>
  //   document.querySelector('#basic-text ~ .half button')
  //     .addEventListener('click', function () {
  //       copyToClipboard("Hello, I'm new content from your clipboard")
  //     });
  //   (function() {
  //     var multilineContainer = document.querySelector('#multiline-text + textarea');
  //     document.querySelector('#multiline-text ~ .half button')
  //       .addEventListener('click', function () {
  //         copyToClipboard(multilineContainer.textContent)
  //       })
  //   })();
  //   (function() {
  //     var markupContainer = document.querySelector('#multiline-markup + textarea');
  //     document.querySelector('#multiline-markup ~ .half button')
  //       .addEventListener('click', function () {
  //         copyToClipboard(markupContainer.textContent)
  //       })
  //   })();
