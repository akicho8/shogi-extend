const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

environment.plugins.set(
  'Provide',
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    "window.jQuery": "jquery",
    "window.$": "jquery",
  })
)

module.exports = environment
