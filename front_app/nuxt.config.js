// require('dotenv').config()
// console.log(`.env.${process.env.NODE_ENV}`)
// console.log(process.env.FOO)

// export default {
const config = {
  mode: 'spa',
  // mode: 'universal',

  router: {
    base: process.env.NODE_ENV === 'production' ? "/s" : "/",
  },

  // generate: {
  //   // subFolders: false,
  //   dir: '../public', // Railsの / を直接置き換える
  // },

  /*
  ** Headers of the page
  */
  head: {
    title: null,
    titleTemplate: `%s - ${process.env.npm_package_name}`,
    htmlAttrs: {
      lang: "ja",
      class: process.env.NODE_ENV,
    },
    meta: [
      // https://ja.nuxtjs.org/faq/duplicated-meta-tags/
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: process.env.npm_package_description || '' },
      { name: "action-cable-url", content: (process.env.NODE_ENV === 'development' ? "http://localhost:3000" : "") + "/x-cable" },

      { hid: "og:site_name",   property: "og:site_name",   content: "SHOGI-EXTEND" },
      { hid: "og:type",        property: "og:type",        content: "website" },
      { hid: "og:url",         property: "og:url",         content: "https://example.com" },
      { hid: "og:title",       property: "og:title",       content: "SHOGI-EXTEND" },
      { hid: "og:description", property: "og:description", content: "将棋に関連する便利サービスを提供するサイトです" },
      { hid: "og:image",       property: "og:image",       content: "https://example.com/img/ogp/common.jpg" },

      { hid: "og:card",       property: "og:card",       content: "summary_large_image" },
      { hid: "og:site",       property: "og:site",       content: "@sgkinakomochi" },
      { hid: "og:creator",    property: "og:creator",    content: "@sgkinakomochi" },

    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ],
    // base: { href: "http://localhost:3000" },
  },
  /*
  ** Customize the progress-bar color
  */
  loading: { color: '#fff' },
  /*
  ** Global CSS
  */
  css: [
    // 'application.sass'
    // '../app/javascript/stylesheets/bulma_init.scss',
    // '~/assets/css/buefy.scss',
    // '~/assets/sass/application.sass',
    '../app/javascript/stylesheets/application.sass',
    '~/assets/sass/application.sass',
  ],
  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    "~/plugins/mixin_mod.js",
    "~/plugins/axios_mod.js",
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
  ],
  /*
  ** Nuxt.js modules
  */
  modules: [
    // Doc: https://buefy.github.io/#/documentation
    'nuxt-buefy',
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    '@nuxtjs/proxy',
    '@nuxtjs/pwa',
    // Doc: https://github.com/nuxt-community/dotenv-module
    // ['@nuxtjs/dotenv', { filename: `.env.${process.env.NODE_ENV}` }],
    '@nuxtjs/dotenv',
  ],
  /*
  ** Axios module configuration
  ** See https://axios.nuxtjs.org/options
  */
  axios: {
    debug: process.env.NODE_ENV === 'development',
    proxy: process.env.NODE_ENV === 'development',
    // // baseURL: process.env.API_URL,
    credentials: true,          // これを入れないと /talk のとき HTML が返ってきてしまう
  },

  proxy: {
    // "/api": "http://localhost:3000",
    // "/api": "http://localhost:3000",
    // "/api": "http://localhost:3000",
    // "/api": {
    //   target: "http://localhost:3000",
    // },
  },

  /*
  ** Build configuration
  */
  // https://ja.nuxtjs.org/faq/webpack-audio-files/
  build: {
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
  // 全体で共有する動的(？)な定義
  publicRuntimeConfig: {
    FOO: "",
  },
  // SSR側での定義で publicRuntimeConfig を上書きする
  privateRuntimeConfig: {},

  // ここで定義すると vue 側に渡せるが融通が効かないため publicRuntimeConfig を使う方がよい
  env: {
    MY_ENV: process.env.MY_ENV,
    FOO: process.env.FOO,
  },
}

if (process.env.NODE_ENV === 'development') {
  config.proxy["/api"] = "http://localhost:3000"
}

export default config
