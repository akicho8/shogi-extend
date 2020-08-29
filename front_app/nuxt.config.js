require('dotenv').config()

export default {
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
    title: process.env.npm_package_name || '',
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
    '@nuxtjs/dotenv',
  ],
  /*
  ** Axios module configuration
  ** See https://axios.nuxtjs.org/options
  */
  axios: {
    debug: true,
    proxy: true,
    // // baseURL: process.env.API_URL,
    credentials: true,          // これを入れないと /talk のとき HTML が返ってきてしまう
  },

  proxy: {
    // "/api": "http://localhost:3000",
    // "/api": "http://localhost:3000",
    "/api": "http://localhost:3000",
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
}
