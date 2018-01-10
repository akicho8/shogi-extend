const environment = require('./environment')

if (true) {
  // class 構文が解釈されない問題に対処する
  //
  // ▼【webpack】(2018年1月現時点で)ES2015 (ES6)のままminifyする方法 - Qiita
  // https://qiita.com/ota-meshi/items/9e9bfcbfab00e109494f
  //
  // ~/src/shogi_web/node_modules/@rails/webpacker/package/environments/production.js で定義しているのは古い(ecmaオプションなどが無い) uglifyjs 用
  const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
  environment.plugins.delete('UglifyJs')

  environment.plugins.append(
    'UglifyJs',
    new UglifyJsPlugin({
      sourceMap: true,
      uglifyOptions: {
        ecma: 6,
        // beautiful: true,
        // mangle: {
        //   safari10: true,
        // },
        // compress: {
        //   warnings: false,
        //   comparisons: false,
        // },
        // output: {
        //   comments: false,
        //   ascii_only: true,
        // }
      },
    })
  )
}

module.exports = environment.toWebpackConfig()
