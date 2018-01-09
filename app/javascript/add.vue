<template>
<p>{{a}} + {{b}} = {{c}}</p>
</template>

<script>
export default {
  props: ["a", "b"],
  computed: {
    c: function () {
      return this.a + this.b;
    }
  }
}
</script>

<style scoped>
p {
    color: blue;
}
</style>
