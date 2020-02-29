// ▼webpacker/compiler.rb at master · rails/webpacker
// https://github.com/rails/webpacker/blob/master/lib/webpacker/compiler.rb
// で WEBPACKER_RELATIVE_URL_ROOT が追加されたのでそのうち↓これは不要になるはず

const publicPath = {
  // production:  process.env.USE_NEW_DOMAIN ? '/packs/' : '/shogi/packs/',
  production:  '/packs/',
  development: '/packs/',
  test:        '/packs-test/',
}[process.env.NODE_ENV]

module.exports = {
  test: /\.(mp3|wav|jpg|jpeg|png|gif|tiff|ico|svg|eot|otf|ttf|woff|woff2)$/i,
  use: [
    {
      loader: 'file-loader', // http://devdocs.io/webpack/loaders/file-loader
      options: {
        publicPath: publicPath,
        outputPath: 'files/',
        // context: "app/javascript", // 基準ディレクトリ。name に [path] が含まれるときに書いたぶんだけ省略できる。デフォルトは Rails.root になっている
        name: '[name]-[hash].[ext]', // [path]
        // useRelativePath: true,    // outputPath を見ないで url(../../foo.png) のような構造を維持する
      },
    },
  ],
}
