// export default {
const config = {
  // mode: 'spa',
  mode: 'universal',

  /*
  ** Nuxt target
  ** See https://nuxtjs.org/api/configuration-target
  */
  target: 'server',

  router: {
    base: process.env.NODE_ENV === 'production' ? "/app/" : "/",
  },

  generate: {
    subFolders: false,  // false: xxx.html true: xxx/index.html
    // dir: '../public', Railsの / を直接置き換える
  },

  /*
  ** Headers of the page
  */
  head: {
    title: "TOP",
    titleTemplate: `%s - SHOGI-EXTEND`,
    htmlAttrs: {
      lang: "ja",
      prefix: 'og: http://ogp.me/ns#',
      class: process.env.NODE_ENV,
    },
    meta: [
      // https://ja.nuxtjs.org/faq/duplicated-meta-tags/
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: "将棋に関連する便利サービスを提供するサイトです" },
      { name: "action-cable-url", content: (process.env.NODE_ENV === 'development' ? "http://localhost:3000" : "") + "/x-cable" },

      { hid: "og:site_name",   property: "og:site_name",   content: "SHOGI-EXTEND" },
      { hid: "og:type",        property: "og:type",        content: "website" },
      { hid: "og:url",         property: "og:url",         content: process.env.SITE_URL }, // これいるのか？

      // 重要なのはこの4つだけで各ページで上書きする
      { hid: "og:title",       property: "og:title",       content: "SHOGI-EXTEND" },
      { hid: "og:description", property: "og:description", content: "将棋に関連する便利サービスを提供するサイトです" },
      { hid: "og:image",       property: "og:image",       content: process.env.OGP_BASE_URL + "/ogp/application.png" },
      { hid: "twitter:card",   property: "twitter:card",   content: "summary" }, // summary or summary_large_image

      { hid: "twitter:site",       property: "twitter:site",       content: "@sgkinakomochi" }, // これいるのか？
      { hid: "twitter:creator",    property: "twitter:creator",    content: "@sgkinakomochi" }, // これいるのか？

    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ],
    // base: { href: "http://localhost:3000" },
  },
  /*
  ** Customize the progress-bar color
  */
  loading: { color: 'hsl(348, 100%, 61%)' }, // bulma danger red color
  /*
  ** Global CSS
  */
  css: [
    // 'application.sass'
    // '../app/javascript/stylesheets/bulma_init.scss',
    // '~/assets/css/buefy.scss',
    // '~/assets/sass/application.sass',
    // '../app/javascript/stylesheets/application.sass',
    './assets/sass/application.sass',
    // '@/assets/custom-styles.scss'
  ],
  styleResources: {
    sass: [
      './assets/sass/resource.scss', // FIXME: なぜか sass の項目に *.scss のファイルを与えないと読み込まれない
    ],
    // scss: [
    //   // "../app/javascript/stylesheets/bulma_init.scss",
    //   // '~assets/vars/*.scss',
    //   // '~assets/abstracts/_mixins.scss'
    // ]
  },

  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    "~/plugins/mixin_mod.client.js",
    "~/plugins/axios_mod.js",
    "~/plugins/universal.js",
  ],
  /*
  ** Auto import components
  ** See https://nuxtjs.org/api/configuration-components
  */
  components: true,
  /*
  ** Nuxt.js dev-modules
  */
  buildModules: [
    // https://github.com/nuxt-community/analytics-module
    ['@nuxtjs/google-analytics', { id: 'UA-109851345-1' }],
  ],
  /*
  ** Nuxt.js modules
  */
  modules: [
    // Doc: https://buefy.github.io/#/documentation
    ['nuxt-buefy', {css: false}],
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    '@nuxtjs/proxy',
    '@nuxtjs/pwa',
    '@nuxtjs/style-resources',
  ],
  /*
  ** Axios module configuration
  ** See https://axios.nuxtjs.org/options
  */
  axios: {
    debug: process.env.NODE_ENV === 'development',
    proxy: process.env.NODE_ENV === 'development',
    baseURL: process.env.SITE_URL, // generate する staging では proxy が無効になり https://shogi-flow.xyz/api/* を叩かせる
    credentials: true,             // これを入れないと /api/talk のとき HTML が返ってきてしまう
  },

  proxy: {
    // 下で設定している
  },

  /*
  ** Build configuration
  */
  // オーディオファイルをロードするように Webpack の設定を拡張するには？
  // https://ja.nuxtjs.org/faq/webpack-audio-files
  build: {
    // https://ja.nuxtjs.org/api/configuration-build#extractcss
    extractCSS: process.env.NODE_ENV === "production", // htmlファイルにスタイルが吐かれるのを防ぐ。trueにするとHMRが効かないので注意

    // TODO: 意味を調べる
    optimization: {
      splitChunks: {
        cacheGroups: {
          styles: {
            name: 'styles',
            test: /\.(scss|sass|css|vue)$/,
            chunks: 'all',
            enforce: true,
          },
        },
      },
    },

    // https://ja.nuxtjs.org/api/configuration-build/#transpile
    transpile: ["shogi-player"], // 外側にあるファイルは import 文を require に変換しないと node でパースできない

    loaders: {
      vue: {
        transformAssetUrls: {
          audio: 'src'
        }
      }
    },

    extend (config, ctx) {
      config.module.rules.push({
        test: /\.(ogg|mp3|wav|mpe?g)$/i,
        loader: 'file-loader',
        options: {
          name: '[path][name].[ext]'
        },
      })
    },
  },

  // https://nuxtjs.org/guide/runtime-config
  // 空文字列は空で設定したのではなく XXX: process.env.XXX の意味(この仕様は余計にわかりにくい)
  publicRuntimeConfig: {
    SITE_URL:     "",
    OGP_BASE_URL: "",
  },

  // SSR側での定義で publicRuntimeConfig を上書きする
  privateRuntimeConfig: {},

  // 面倒な process.env.XXX の再定義
  // ・ここで定義すると .vue 側で process.env.XXX で参照できる
  // ・が、だとテンプレートで使えなかったり単なる文字列だったり process.env が空だったりでデバッグしにくい
  // ・ので publicRuntimeConfig を使う方がよい
  // ・NUXT_ENV_ プレフィクスをつけた環境変数は自動的にここで定義したことになる(プレフィクスはついたまま)
  // ・だけど publicRuntimeConfig を使う方がまし
  env: {
    // FOO: process.env.FOO,
  },
}

if (process.env.NODE_ENV === 'development') {
  config.proxy["/api"]    = "http://0.0.0.0:3000"
  config.proxy["/system"] = "http://0.0.0.0:3000" // for mp3
}

export default config
