const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')
const vue =  require('./loaders/vue')
const file =  require('./loaders/file')
const webpack = require('webpack')

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    "window.jQuery": "jquery",
    "window.$": "jquery",
  })
)

environment.loaders.append('vue', vue)
environment.loaders.append('coffee', coffee)
environment.loaders.append('file', file) // 自分で定義した loaders/file.js を使う
module.exports = environment
