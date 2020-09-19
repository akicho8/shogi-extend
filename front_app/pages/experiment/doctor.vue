<template lang="pug">
.doctor
  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item(tag="nuxt-link" :to="{name:'index'}" exact-active-class="is-active") TOP
    template(slot="start")
      b-navbar-item(tag="nuxt-link" :to="{name:'experiment-doctor'}" exact-active-class="is-active") DOCTOR
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
      .column
        .title Server
        .box
          .block
            .title $config
            pre {{SSR_config}}
          .block
            .title ENV_BUILD_VERSION
            pre {{SSR_ENV_BUILD_VERSION}}
</template>

<script>
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
    }
  },
}
</script>
