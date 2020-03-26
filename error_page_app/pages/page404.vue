<template lang="pug">
  robot
    | ページガミツカリマセン
</template>

<script>
import Robot from "~/components/Robot"

export default {
  name: "404",
  components: {
    Robot,
  },
  head: {
    title: 'Not Found',
    meta: [ { "http-equiv": "refresh", content: "60;url=/" } ],
  },
}
</script>
