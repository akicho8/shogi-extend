export default {
  ssr: true,
  target: "server",
  build: {
    babel: {
      plugins: [
        "@babel/plugin-proposal-logical-assignment-operators",
      ],
    },

    // postcss: {
    //   postcssOptions: {
    //     // キーとしてプラグイン名を、値として引数を追加します
    //     // プラグインは前もって npm か yarn で dependencies としてインストールしておきます
    //     plugins: {
    //       // // 値として false を渡すことによりプラグインを無効化します
    //       // 'postcss-url': false,
    //       // // lost: true,
    //       // // 'postcss-nested': false,
    //       // // 'postcss-responsive-type': false,
    //       // // 'postcss-hexrgba': false,
    //       // 'postcss-cssnext': false,
    //     },
    //   },
    //   preset: {
    //     // postcss-preset-env 設定を変更します
    //     // autoprefixer: {
    //     //   grid: false,
    //     // },
    //   },
    // },

  },
}
