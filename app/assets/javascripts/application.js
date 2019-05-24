//  require rails-ujs
//  require jquery
//  require bootstrap-sprockets
//= require_tree .

////////////////////////////////////////////////////////////////////////////////
if (typeof(jQuery) != "undefined") {
  console.log('[Sprockets]jQuery: OK')
  if (typeof($) != "undefined") {
    console.log('[Sprockets]$: OK')
  } else {
    console.log('[Sprockets]$: Missing')
  }
} else {
  console.log('[Sprockets]jQuery: Missing')
}
