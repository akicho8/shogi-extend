<template lang="pug">
  robot
    | ナンカオカシクナッタ
</template>

<script>
import Robot from "~/components/Robot"

export default {
  name: "422",
  components: {
    Robot,
  },
  head: {
    title: 'Unprocessable Entity',
    meta: [ { "http-equiv": "refresh", content: "30;url=/" } ],
  },
}
</script>
