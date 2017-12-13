/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "./bootstrap_basic.sass"
import "./bootstrap_tuning.sass"
import "./modulable_crud.coffee"

////////////////////////////////////////////////////////////////////////////////
if (typeof(jQuery) != "undefined") {
  console.log('[Webpack]jQuery: OK')
  if (typeof($) != "undefined") {
    console.log('[Webpack]$: OK')
    if (typeof($().tooltip) != "undefined") {
      console.log('[Webpack]Bootstrap JS: OK')
    } else {
      console.log('[Webpack]Bootstrap JS: Missing')
    }
  } else {
    console.log('[Webpack]$: Missing')
  }
} else {
  console.log('[Webpack]jQuery: Missing')
}
////////////////////////////////////////////////////////////////////////////////

