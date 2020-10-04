<template>
  <div id="app">
    <p>{{message}}</p>
    <p>v1={{v1}}</p>
</div>
</template>

<script>
export default {
  props: ["v1"],
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped lang="scss">
</style>
