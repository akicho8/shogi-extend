<template lang="pug">
ul
  li process.env.BASE_URL: {{process_env.BASE_URL}}
</template>

<script>
export default {
  name: 'env',
  data() {
    return {
      process_env: process.env,
    }
  },
}
</script>
