<template lang="pug">
span.has-text-weight-normal
  template(v-if="record.previous_runner_up_count >= 1")
    template(v-for="i in record.previous_runner_up_count")
      span.ml-1.has-text-grey-light 次
  template(v-if="record.level_up_p")
    span.ml-1.has-text-danger.has-text-weight-bold 昇
  template(v-if="record.runner_up_p")
    span.ml-1.has-text-danger 次
  template(v-if="record.level_down_p")
    span.ml-1.has-text-weight-bold 降
</template>

<script>
export default {
  props: ["record"],
}
</script>
