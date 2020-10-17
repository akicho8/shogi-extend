<template lang="pug">
client-only
  .doctor
    MainNavbar
      template(slot="brand")
        b-navbar-item(tag="nuxt-link" :to="{name:'experiment-doctor'}" exact-active-class="is-active") DOCTOR
      template(slot="start")
      template(slot="end")
        b-navbar-item(tag="nuxt-link" :to="{name:'index'}" exact-active-class="is-active") TOP
    .section
      .columns
        .column
          .title Client
          .box
            .block
              .title $config
              pre {{$config}}
            .block
              .title ENV_BUILD_VERSION
              pre {{CSR_ENV_BUILD_VERSION}}
            .block
              .title $route.query
              pre {{$route.query}}
        .column
          .title Server
          .box
            .block
              .title $config
              pre {{SSR_config}}
            .block
              .title ENV_BUILD_VERSION
              pre {{SSR_ENV_BUILD_VERSION}}
            .block
              .title CURRENT_TIME
              pre {{CURRENT_TIME}}
</template>

<script>
import dayjs from "dayjs"

export default {
  name: "doctor",
  data() {
    return {
      CSR_ENV_BUILD_VERSION: process.env.ENV_BUILD_VERSION,
    }
  },
  async asyncData({$config}) {
    return {
      SSR_config: $config,
      SSR_ENV_BUILD_VERSION: process.env.ENV_BUILD_VERSION,
      CURRENT_TIME: dayjs().format("YYYY-MM-DD HH:mm:ss"),
    }
  },
}
</script>
