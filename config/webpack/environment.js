const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

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

environment.loaders.append('vue', vue)
module.exports = environment
