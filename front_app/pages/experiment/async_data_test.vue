<template lang="pug">
.async_data_test
  .box
    | {{time}}
  hr
  nuxt-link(:to="{name:'index'}" exact-active-class="is-active") TOP
</template>

<script>

export default {
  name: "async_data_test",
  async asyncData({ $axios }) {
    const time = (new Date()).toString()
    return { time }

    // if (process.server) {
    //   // const childProcess = require('child_process');
    //   childProcess.exec('date', (error, stdout, stderr) => {
    //     if(error) {
    //       // エラー時は標準エラー出力を表示して終了
    //       console.log(stderr);
    //       return;
    //     }
    //     else {
    //       // 成功時は標準出力を表示して終了
    //       console.log(stdout);
    //     }
    //   })
    // }
  },
}
</script>

<style lang="sass">
</style>
