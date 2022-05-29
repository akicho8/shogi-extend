<template lang="pug">
.column
  nav.level.is-mobile
    .level-item.has-text-centered
      div
        .heading 直近の実サンプル数
        .title {{xi.sample_count}}
    .level-item.has-text-centered
      div
        .heading 絞り込み後の件数
        .title {{xi.real_total_count}}
</template>

<script>
export default {
  name: "SwarsHistogramSampleCount",
  props: {
    xi: { type: Object, required: true },
  },
}
</script>
