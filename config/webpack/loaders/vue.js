const path = require('path')

const { dev_server: devServer } = require('@rails/webpacker').config

const isProduction = process.env.NODE_ENV === 'production'
const inDevServer = process.argv.find(v => v.includes('webpack-dev-server'))
const extractCSS = !(inDevServer && (devServer && devServer.hmr)) || isProduction

module.exports = {
  test: /\.vue(\.erb)?$/,
  use: [{
    loader: 'vue-loader',
    options: {
      extractCSS,

      // // TODO: どうやって global_css_test.sass を読み込めばいいんだ？
      // loaders: {
      //   sass: 'vue-style-loader!css-loader!sass-loader?data=@import "global_css_test.sass"',
      //   // css: {
      //   //   loader: 'css-loader',
      //   // },
      //   // scss: {
      //   //   loader: 'sass-loader',
      //   //   options: {
      //   //     data: '@import "global_css_test.sass";',
      //   //     // import: [path.resolve(__dirname, '../src/assets/stylus/colors.styl')],
      //   //     includePaths: [path.resolve(__dirname, './app/javascript/')],
      //   //   },
      //   // },
      // },
    },
  }],
}
