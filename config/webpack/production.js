const environment = require('./environment')

// ~/src/shogi_web/node_modules/@rails/webpacker/package/environments/production.js
if (true) {
  const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
  environment.plugins.delete('UglifyJs')
  environment.plugins.append(
    'UglifyJs',
    new UglifyJsPlugin({
      sourceMap: true,
    })
  )
}

module.exports = environment.toWebpackConfig()
