<template lang="pug">
p {{a}}
</template>

<script>
export default {
  data() {
    return {
      a: null,
    }
  },
  mounted() {
    this.a ||= "ok"
  },
}
</script>
