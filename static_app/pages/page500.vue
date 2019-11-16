<template lang="pug">
  robot
    | ブッコワレマシタ<br>
    | モンダイワスデニキロクズミデス<br>
    | ゴメイワクヲオカケシテスミマセン<br>
</template>

<script>
import Robot from "~/components/Robot"

export default {
  name: "500",
  components: {
    Robot,
  },
  head: {
    title: 'Internal Server Error',
  },
}
</script>
